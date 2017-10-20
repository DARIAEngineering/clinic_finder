require 'ostruct'

module ClinicFinder
  # Functionality pertaining to geography
  module Geocoder
    def get_patient_coordinates_from_zip(zipcode)
      patient_location = ::Geokit::Geocoders::GoogleGeocoder.geocode(zipcode)
      @patient.location = patient_location.ll
    end

    def add_clinic_full_address
      @clinic_structs.each do |clinic|
        clinic.full_address = "#{clinic.street_address}, " \
                              "#{clinic.city}, #{clinic.state}"
      end
    end

    def determine_clinic_coordinates
      @clinic_structs.each do |clinic| # {name: 'Oakland Clinic', address: '101 Main St, Oakland, CA'}
        location = ::Geokit::Geocoders::GoogleGeocoder.geocode clinic.full_address
        sleep(0.5) # TODO figure out workaround. probably slamming in api key
        coordinates = location.ll.split(',').map(&:to_f)

        clinic.coordinates = Geokit::LatLng.new(coordinates[0], coordinates[1])
      end
    end

    def calculate_distances
      @clinic_structs.each do |clinic|
        clinic.distance = clinic.coordinates.distance_to(@patient.location)
      end
    end
  end
end
