require 'test_helper'
require_relative '../lib/clinic_finder'


class TestClinicFinder < TestClass


  # test '#apply_subscription' do
  #  	mock = Minitest::Mock.new
  #  	mock.expect :clinics_coordinates_conversion, true
		
  #  	SubscriptionService.stub :new, mock do
  #  		user = users(:one)
  #  		assert user.apply_subscription
  #  	end
		
  #  	assert_mock mock # New in Minitest 5.9.0
  #  	assert mock.verify # Old way of verifying mocks
  # end



  def setup
  	file = File.join(File.dirname(__FILE__), '../fixtures/clinics.yml')
  	@abortron = Abortron::ClinicFinder.new(file)
  end

  def test_that_initialize_sets_clinic_variable
  	assert_kind_of Hash, @abortron.clinics
  end
  	 
  def test_that_full_addresses_created
  	assert_kind_of Array, @abortron.create_full_address(@abortron.clinics)
  end

  def test_that_full_address_has_needed_fields
  	assert_equal [["1001 Broadway, Oakland, CA"], ["2430 Folsom, San Francisco, CA"], ["517 Castro, San Francisco, CA"], ["110 S Market, San Jose, CA"], ["570 Pacific, Monterey, CA"], ["1801 Mountain NW, Albuquerque, NM"], ["7473 Humboldt, Butte Meadows, CA"], ["2220 Tulare, Fresno, CA"], ["2025 Pacific, Los Angeles, CA"], ["3900 W Manchester, Los Angeles, CA"], ["5905 Wilshire, Los Angeles, CA"]], @abortron.create_full_address(@abortron.clinics)
  end

  # def test_that_clinic_coordinates_are_array
  # 	addresses = @abortron.create_full_address(@abortron.clinics)
  # 	assert_kind_of Array, @abortron.clinics_coordinates_conversion(addresses)
  # end

  def test_that_clinic_coordinates_are_found
  	addresses = [["1001 Broadway, Oakland, CA"], ["2430 Folsom, San Francisco, CA"], ["517 Castro, San Francisco, CA"]]
  	obj = MiniTest::Mock.new
		obj.expect :clinics_coordinates_conversion, [["37.8021736, -122.2729171"], ["37.758278,-122.415025"], ["37.7605162,-122.4347025"]], addresses
  end

  # def test_that_address_coordinates_are_string
  # 	addresses = @abortron.create_full_address(@abortron.clinics)
  # 	addresses.each do |address|
  # 		address.each do |coordinates|
  # 			@coordinates = @abortron.clinics_coordinates_conversion(coordinates)
  # 			p @coordinates
  # 		end
  # 	end
  # 	assert_kind_of String, @coordinates
  # end

  def test_that_coordinates_are_found_for_patient
  end

  def test_that_distances_calculated_between_clinics_and_patient

  end

end
