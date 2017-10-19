require 'ostruct'

module Abortron
  # Functionality pertaining to geography
  module Geocoder
    def patient_coordinates_from_zip(zipcode)
      patient_location = ::Geokit::Geocoders::GoogleGeocoder.geocode(zipcode)
      patient_location.ll
    end

    def build_full_address(clinics)
      clinics.map do |clinic|
        OpenStruct.new name: clinic.name,
                       full_address: "#{clinic.street_address}, "
                                     "#{clinic.city}, #{clinic.state}"
      end
    end

    def clinics_coordinates(clinics)
      clinics.map do |clinic| # {name: 'Oakland Clinic', address: '101 Main St, Oakland, CA'}
        location = ::Geokit::Geocoders::GoogleGeocoder.geocode clinic[:full_address]
        sleep(0.5) # TODO figure out workaround. probably slamming in api key
        coordinates = location.ll.split(',').map(&:to_f)

        OpenStruct.new name: clinic.name,
                       full_address: clinic.full_address,
                       coordinates: Geokit::LatLng.new(coordinates[0], coordinates[1])
      end
    end

    def calculate_distances(clinics, patient_coordinates)
      clinics.map do |clinic|
        OpenStruct.new name: clinic.name,
                       full_address: clinic.full_address,
                       coordinates: clinic.coordinates,
                       distance: clinic.coordinates.distance_to(patient_coordinates)
      end
    end
  end
end
