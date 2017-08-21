require 'yaml'
require 'geokit'
require_relative './clinic_finder/gestation_helper'
require_relative 'clinic_finder/affordability_helper'
require_relative 'clinic_finder/geocoding_helper'

# Core class
module Abortron
class ClinicFinder
  attr_reader :clinics

  def initialize(clinics, gestational_age: 999, naf_only: false, medicaid_only: false)
    @clinics = filter_by_params clinics,
                                gestational_age,
                                naf_only,
                                medicaid_only
  end

  def find_closest_clinics
    @distances[0..4]
  end

  # need to write test to make sure everything gets called
  def locate_nearest_clinic(patient_zipcode, limit: 5)
    patient_coordinates = patient_coordinates_conversion(patient_zipcode)
    clinics_with_address = create_full_address @clinics
    clinics_coordinates_conversion clinics_with_address
    calculate_distance
    find_closest_clinics
  end

  def locate_cheapest_clinic(gestational_age: 999, limit: 5)
    # @helper = ::ClinicFinder::GestationHelper.new(gestational_age)
    # filtered_clinics = filter_by_params gestational_age, naf_only, medicaid_only

    # @gestational_tier = @helper.gestational_tier
    decorate_data(available_clinics)
  end

  private

  def filter_by_params(clinics, gestational_age, naf_only, medicaid_only)
    filtered_clinics = clinics.keep_if do |clinic|
      gestational_age < clinic.gestational_limit &&
        (naf_only ? clinic.accepts_naf : true) &&
        (medicaid_only ? clinic.accepts_medicaid : true)
    end
    filtered_clinics
  end

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
