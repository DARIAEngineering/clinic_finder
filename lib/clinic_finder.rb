require 'yaml'
require 'geokit'
# require_relative './clinic_finder/gestation_helper'
# require_relative 'clinic_finder/affordability_helper'
require 'clinic_finder/geocoder'

# Core class. Top level stuff to invoke are:
# * ClinicFinder::Locator#locate_nearest_clinics
# * ClinicFinder::Locator#locate_cheapest_clinics
module ClinicFinder
  class Locator
    include ClinicFinder::Geocoder

    attr_accessor :clinics
    attr_accessor :clinic_structs # a scratch version of clinics
    attr_accessor :patient_context # no reason to not assign this to an obj level

    def initialize(clinics, gestational_age: 999, naf_only: false, medicaid_only: false)
      filtered_clinics = filter_by_params clinics,
                                          gestational_age,
                                          naf_only,
                                          medicaid_only

      @clinics = filtered_clinics
      @clinic_structs = filtered_clinics.map do |clinic|
        data = if clinic.is_a? OpenStruct
          clinic.marshal_dump
        else
          clinic.attributes # ActiveRecord, Mongoid, etc.
        end
        OpenStruct.new data
      end
      @patient_context = OpenStruct.new
    end

    # Return a set of the closest clinics and their attributes,
    # distance included, to a patient's zipcode.
    # TODO: Clinic objects or just structs?
    def locate_nearest_clinics(zipcode, limit: 5)
      get_patient_coordinates_from_zip zipcode
      add_distances_to_clinic_openstructs

      @clinic_structs.sort_by(&:distance).reverse.take(limit)
    end

    # Return a set of the cheapest clinics and their attributes.
    # TODO: Implement.
    def locate_cheapest_clinic(gestational_age: 999, limit: 5)
      puts 'NOT IMPLEMENTED YET'
      # @helper = ::ClinicFinder::GestationHelper.new(gestational_age)
      # filtered_clinics = filter_by_params gestational_age, naf_only, medicaid_only

      # @gestational_tier = @helper.gestational_tier
      # decorate_data(available_clinics)
    end

    private

    # Based on initialization fields, narrow the list of clinics to
    # just what we need.
    def filter_by_params(clinics, gestational_age, naf_only, medicaid_only)
      filtered_clinics = clinics.keep_if do |clinic|
        gestational_age < (clinic.gestational_limit || 1000) &&
          (naf_only ? clinic.accepts_naf : true) &&
          (medicaid_only ? clinic.accepts_medicaid : true)
      end
      filtered_clinics
    end

    # This method makes the sorted clinic data more easily traversible by converting the data into a hash of names (keys) and informational attributes (values) rather than leaving them as separate values in a nested array.
    # def decorate_data(data)
    #   sorted_clinics = []
    #   three_cheapest(data).map { |clinic_array| sorted_clinics << { name: clinic_array.first, cost: clinic_array.last[@gestational_tier] } }
    #   sorted_clinics
    # end

    # def three_cheapest(data)
    #   data.sort_by { |name, information| information[@gestational_tier] }.first(3)
    # end

    # def available_clinics
    #   @clinics.keep_if { |name, information| information[@gestational_tier] && @helper.within_gestational_limit?(information['gestational_limit']) }
    # end
  end
end
