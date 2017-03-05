require 'clinic_finder/template'
require 'yaml'
require 'geokit'

# Core class
module Abortron
class ClinicFinder
	attr_reader :clinics

  def initialize(yml_file)
		@clinics = ::YAML.load_file(yml_file)
  end

  def create_full_address
    @clinic_addresses = []
    @clinics.each do |clinic, info|
      @clinic_addresses << {name: clinic, address: "#{info['street_address']}, #{info['city']}, #{info['state']}"}
    end
    @clinic_addresses
  end

  def clinics_coordinates_conversion
    @coordinates_hash = {}
    @clinic_addresses.map! do |address| # {name: 'Oakland Clinic', address: '101 Main St, Oakland, CA'}
      location = ::Geokit::Geocoders::GoogleGeocoder.geocode(address[:address])
      float_coordinates = location.ll.split(',').map(&:to_f)
      @coordinates_hash[address[:name]] = float_coordinates
      sleep(0.5)
    end
    @coordinates_hash
  end

  def patient_coordinates_conversion(patient_zipcode)
    @patient_location = ::Geokit::Geocoders::GoogleGeocoder.geocode(patient_zipcode)
    @patient_float_coordinates = @patient_location.ll
  end

  def calculate_distance
    distances = []
    @coordinates_hash.each do |name, coordinates|
      ll = Geokit::LatLng.new(coordinates[0], coordinates[1])
      distances << {name: name, distance: ll.distance_to(@patient_float_coordinates)}
      # distances = [ {name: "Oakland", distance: 2}, {name: "San Francisco", distance: 1} ]
    end
    @distances = distances.sort {|distance| distance[:distance]}
  end


  def find_closest_clinics
    @distances[0..2]
  end

end
end
