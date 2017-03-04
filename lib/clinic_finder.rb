require 'yaml'

# Core class
module Abortron
class ClinicFinder
	attr_reader :clinics

  def initialize(yml_file)
		@clinics = ::YAML.load_file(yml_file)
  end

  # def locate_cheapest_clinic(patient_zip:, gestational_age:, naf_clinics_only: false)

  # end
end
end
