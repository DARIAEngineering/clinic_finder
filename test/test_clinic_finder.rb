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



end


