require 'clinic_finder/template'
require 'yaml'

# Core class
module Abortron
class ClinicFinder
	attr_reader :clinics

  def initialize(yml_file)
		@clinics = ::YAML.load_file(yml_file)
  end
end
end
