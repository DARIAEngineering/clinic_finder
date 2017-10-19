module Abortron
  # Functionality pertaining to geography
  class ClinicFinder::Geocoder
    def patient_coordinates_conversion(patient_zipcode)
      patient_location = ::Geokit::Geocoders::GoogleGeocoder.geocode(patient_zipcode)
      patient_location.ll
    end

    def create_full_address(clinics)
      clinic_addresses = clinics.map do |clinic|
        { name: clinic.name,
          full_address: "#{clinic.street_address}, #{clinic.city}, #{clinic.state}" }
      end
      clinic_addresses
    end

    def clinics_coordinates_conversion(clinics)
      geocoded_clinics = clinics.map do |clinic| # {name: 'Oakland Clinic', address: '101 Main St, Oakland, CA'}
        location = ::Geokit::Geocoders::GoogleGeocoder.geocode(clinic[:full_address])
        float_coordinates = location.ll.split(',').map(&:to_f)
        coordinates_hash[address[:name]] = float_coordinates
        sleep(0.5) # TODO figure out workaround
      end
      coordinates_hash
    end

    def calculate_distance()
      distances = []
      @coordinates_hash.each do |name, coordinates|
        ll = Geokit::LatLng.new(coordinates[0], coordinates[1])
        distances << {name: name, distance: ll.distance_to(@patient_float_coordinates)}
        # distances = [ {name: "Oakland", distance: 2}, {name: "San Francisco", distance: 1} ]
      end
      @distances = distances.sort_by {|distance| distance[:distance]}
    end
  end
end
