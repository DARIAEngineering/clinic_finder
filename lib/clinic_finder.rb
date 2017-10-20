require 'yaml'
require 'geokit'
require_relative './clinic_finder/gestation_helper'
require_relative 'clinic_finder/affordability_helper'
require_relative 'clinic_finder/geocoding_helper'

# Core class. Top level stuff to invoke are:
# * locate_nearest_clinics
# * locate_cheapest_clinics
module Abortron
  class ClinicFinder
    include Geocoder

    attr_reader :clinics
    attr_accessor :patient # no reason to not assign this to an obj level

    def initialize(clinics, gestational_age: 999, naf_only: false, medicaid_only: false)
      filtered_clinics = filter_by_params clinics,
                                          gestational_age,
                                          naf_only,
                                          medicaid_only

      @clinics = filtered_clinics # TODO turn these into ostructs
    end

    # need to write test to make sure everything gets called
    def locate_nearest_clinics(zipcode, limit: 5)
      patient_coordinates = patient_coordinates_from_zip zipcode
      clinics_with_address = build_full_address @clinics
      clinics_with_coordinates = clinics_coordinates clinics_with_address
      clinics_with_distance = calculate_distances(clinics_with_coordinates, patient_coordinates)
      clinics_with_distance.sort_by(&:distance).reverse.take(limit)
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
