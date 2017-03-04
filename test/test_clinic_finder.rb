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
  	 
  def test_that_full_addresses_created
  	assert_kind_of Array, @abortron.create_full_address(@abortron.clinics)
  	# p @abortron.create_full_address(@abortron.clinics)
  end

  def test_that_full_address_has_needed_fields
  	addresses = @abortron.create_full_address(@abortron.clinics)
  	assert_equal [["1001 Broadway, Oakland, CA"], ["2430 Folsom, San Francisco, CA"], ["517 Castro, San Francisco, CA"], ["110 S Market, San Jose, CA"], ["570 Pacific, Monterey, CA"], ["1801 Mountain NW, Albuquerque, NM"], ["7473 Humboldt, Butte Meadows, CA"], ["2220 Tulare, Fresno, CA"], ["2025 Pacific, Los Angeles, CA"], ["3900 W Manchester, Los Angeles, CA"], ["5905 Wilshire, Los Angeles, CA"]], @abortron.create_full_address(@abortron.clinics)
  end

  def test_that_clinic_coordinates_are_found

  end

end
