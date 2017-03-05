require 'yaml'
require_relative './clinic_finder/gestation_helper'

# Core class
module Abortron
class ClinicFinder
	attr_reader :clinics

  def initialize(yml_file)
		@clinics = ::YAML.load_file(yml_file)
  end

  def locate_cheapest_clinic(gestational_age:, naf_clinics_only: false)
    helper = ::ClinicFinder::GestationHelper.new(gestational_age)
    gestational_tier = helper.gestational_tier #'cost_9weeks'

    clinics = @clinics.keep_if { |name, information| information[gestational_tier] && helper.within_gestational_limit?(information['gestational_limit']) }

    sorted_clinics = []

    clinics.sort_by { |name, information| information[gestational_tier] }.first(3).map do |clinic_array|
      sorted_clinics << { clinic_array[0] => clinic_array[1] }
    end
    sorted_clinics
  end
end
end
