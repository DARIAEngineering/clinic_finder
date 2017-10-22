require 'minitest/autorun'
require 'clinic_finder'
require 'yaml'
require 'ostruct'
require 'active_support/inflector'

# Convenience methods and the base test class
class TestClass < MiniTest::Spec
  def load_clinic_fixtures
    clinics = YAML.load_file File.join(File.dirname(__FILE__),
                                       './fixtures/clinics.yml')

    # Problem is in here somewhere
    clinics.keys.map do |clinic_name|
      humanized_name = { name: ActiveSupport::Inflector.humanize(clinic_name) }
      # puts clinics[clinic_name].merge(humanized_name)
      Clinic.new clinics[clinic_name].merge(humanized_name)
    end
  end
end

# Mirrors, more or less the DCAF class
class Clinic
  attr_accessor :_id, :name, :street_address, :city,
                :state, :zip, :accepts_naf,
                :accepts_medicaid, :gestational_limit,
                :costs_9wks, :costs_12wks, :costs_18wks,
                :costs_24wks, :costs_30wks

  def initialize(clinic_hash)
    clinic_hash.each_pair { |k, v| instance_variable_set("@#{k}".to_sym, v) }
  end
end
