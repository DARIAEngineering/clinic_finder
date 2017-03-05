require 'clinic_finder/template'
require 'yaml'
require 'geokit'
# require 'clinic_finder/configuration'


# Core class
module Abortron
class ClinicFinder
	attr_reader :clinics

  # class << self
  #   attr_accessor :configuration
  # end

  # def self.configuration
  #   @configuration ||= Configuration.new
  # end

  # def self.reset
  #   @configuration = Configuration.new
  # end

  # def self.configure
  #   yield(configuration)
  # end

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
      location = ::Geokit::Geocoders::MultiGeocoder.geocode(address[:address])
      float_coordinates = location.ll.split(',').map(&:to_f)
      @coordinates_hash[address[:name]] = float_coordinates
    end
    @coordinates_hash
  end

  def patient_coordinates_conversion(patient_zipcode)
    @patient_location = ::Geokit::Geocoders::MultiGeocoder.geocode(patient_zipcode)
    @patient_float_coordinates = @patient_location.ll.first.split(",").map(&:to_f)
  end

  def calculate_distance(coordinates_hash, patient_location)
    @patient_float_coordinates = patient_location
    @coordinates_hash = coordinates_hash
    distances = []
    @coordinates_hash.each do |name, coordinates|
      # p coordinates
      ll = Geokit::LatLng.new(coordinates[:coordinates][0], coordinates[:coordinates][1])
      distances << {name: name, distance: ll.distance_to(@patient_float_coordinates)}
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
