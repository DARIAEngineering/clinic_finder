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
   # returns an array of string formatted addresses for geocoder method
  end

  def clinics_coordinates_conversion
    @coordinates_hash = {}
    @clinic_addresses.map! do |address| # {name: 'Oakland Clinic', address: '101 Main St, Oakland, CA'}
      # address = address.join 
      location = ::Geokit::Geocoders::GoogleGeocoder.geocode(address[:address])
      float_coordinates = location.ll.split(',').map(&:to_f)
      @coordinates_hash[address[:name]] = float_coordinates
    end
    @coordinates_hash
  end
    # array of strings of lat/long

  def patient_coordinates_conversion(patient_zipcode)
    @patient_location = ::Geokit::Geocoders::GoogleGeocoder.geocode(patient_zipcode)
    @patient_location = @patient_location.ll.to_f
  end

  def calculate_distance
    distances = []
    @coordinates_hash.each do |name, coordinates|
      distances << {name: name, distance: coordinates.distance_to(@patient_location)}
      # distances = [ {name: "Oakland", distance: 2}, {name: "San Francisco", distance: 1} ]
    end
    @distances = distances.sort {|distance| distance[:distance]}
    # returns a list of sorted lat/long from patient address
  end


  def find_closest_clinics
    @distances[0..2]
    # returns closest 3 clinics to the patient
  end

end
end