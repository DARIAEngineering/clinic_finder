require 'yaml'
require 'geokit'
require_relative './clinic_finder/gestation_helper'

# Core class
module Abortron
class ClinicFinder
	attr_reader :clinics

  def initialize(yml_file)
		@clinics = ::YAML.load_file(yml_file)
  end

  def create_full_address(gestational_age) # need to test filtering gestational limit
    @clinic_addresses = []
    filtered_clinics = @clinics.keep_if { |name, info| gestational_age < info['gestational_limit']}
    filtered_clinics.each do |clinic, info|
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

  # need to write test to make sure everything gets called
  def locate_nearest_clinic(patient_zipcode:, gestational_age:)
    patient_coordinates_conversion(patient_zipcode)
    create_full_address(gestational_age)
    clinics_coordinates_conversion
    calculate_distance
    find_closest_clinics
  end

  def locate_cheapest_clinic(gestational_age:, naf_clinics_only: false)
    @helper = ::ClinicFinder::GestationHelper.new(gestational_age)
    @gestational_tier = @helper.gestational_tier
    decorate_data(available_clinics)
  end

  # This method makes the sorted clinic data more easily traversible by converting the data into a hash of names (keys) and informational attributes (values) rather than leaving them as separate values in a nested array.
  private def decorate_data(data)
    sorted_clinics = []
    three_cheapest(data).map { |clinic_array| sorted_clinics << { clinic_array.first => clinic_array.last } }
    sorted_clinics
  end

  private def three_cheapest(data)
    data.sort_by { |name, information| information[@gestational_tier] }.first(3)
  end

  private def available_clinics
    @clinics.keep_if { |name, information| information[@gestational_tier] && @helper.within_gestational_limit?(information['gestational_limit']) }
  end
end
end
