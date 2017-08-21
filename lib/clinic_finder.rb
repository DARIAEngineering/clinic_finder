require 'yaml'
require 'geokit'
require_relative './clinic_finder/gestation_helper'
require_relative 'clinic_finder/affordability_helper'
require_relative 'clinic_finder/geocoding_helper'

# Core class
module Abortron
class ClinicFinder
  attr_reader :clinics

  def initialize(clinics)
    @clinics = clinics
  end

  def create_full_address
    filtered_clinics.map do |clinic|
      { name: clinic.name,
        address: "#{clinic.street_address}, #{clinic.city}, #{clinic.state}" }
    end
    clinic_addresses
  end

  def filter_by_params(gestational_age, naf_only, medicaid_only)
    filtered_clinics = @clinics.keep_if do |clinic|
      gestational_age < clinic.gestational_limit &&
        (naf_only ? clinic.accepts_naf : true) &&
        (medicaid_only ? clinic.accepts_medicaid : true)
    end
    filtered_clinics
  end

  def clinics_coordinates_conversion(clinics)
    geocoded_clinics = clinics.map do |clinic| # {name: 'Oakland Clinic', address: '101 Main St, Oakland, CA'}
      location = ::Geokit::Geocoders::GoogleGeocoder.geocode(address[:address])
      float_coordinates = location.ll.split(',').map(&:to_f)
      @coordinates_hash[address[:name]] = float_coordinates
      sleep(0.5) # TODO figure out workaround
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
    @distances = distances.sort_by {|distance| distance[:distance]}
  end

  def find_closest_clinics
    @distances[0..4]
  end

  # need to write test to make sure everything gets called
  def locate_nearest_clinic(patient_zipcode:, gestational_age: 999, naf_only: false, medicaid_only: false)
    patient_coordinates_conversion(patient_zipcode)
    filtered_clinics = filter_by_params gestational_age, naf_only, medicaid_only
    clinics_with_address = create_full_address(filtered_clinics)
    clinics_coordinates_conversion
    calculate_distance
    find_closest_clinics
  end

  def locate_cheapest_clinic(gestational_age: 999, naf_only: false, medicaid_only: false)
    @helper = ::ClinicFinder::GestationHelper.new(gestational_age)
    @gestational_tier = @helper.gestational_tier
    decorate_data(available_clinics)
  end

  private

  # This method makes the sorted clinic data more easily traversible by converting the data into a hash of names (keys) and informational attributes (values) rather than leaving them as separate values in a nested array.
  def decorate_data(data)
    sorted_clinics = []
    three_cheapest(data).map { |clinic_array| sorted_clinics << { name: clinic_array.first, cost: clinic_array.last[@gestational_tier] } }
    sorted_clinics
  end

  def three_cheapest(data)
    data.sort_by { |name, information| information[@gestational_tier] }.first(3)
  end

  def available_clinics
    @clinics.keep_if { |name, information| information[@gestational_tier] && @helper.within_gestational_limit?(information['gestational_limit']) }
  end
end
end
