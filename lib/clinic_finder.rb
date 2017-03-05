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
