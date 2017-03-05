require 'test_helper'
require_relative '../lib/clinic_finder'

class TestClinicFinder < TestClass
  def setup
  	file = File.join(File.dirname(__FILE__), '../fixtures/clinics.yml')
  	@abortron = Abortron::ClinicFinder.new(file)
  end

  def test_that_initialize_sets_clinic_variable
  	assert_kind_of Hash, @abortron.clinics
  end

  def test_locate_cheapest_clinic_locates
    clinic = {
          'planned_parenthood_oakland' =>
          {
            'street_address' => '1001 Broadway',
            'city' => 'Oakland',
            'state' => 'CA',
            'zip' => 94607,
            'accepts_naf' => false,
            'gestational_limit' => 139,
            'costs_9wks' => 425,
            'costs_12wks' => 475,
            'costs_18wks' => 975,
            'costs_24wks' => nil,
            'costs_30wks' => nil
          }
        }
    assert_equal clinic, @abortron.locate_cheapest_clinic(gestational_age: 100)[0]
  end
end
