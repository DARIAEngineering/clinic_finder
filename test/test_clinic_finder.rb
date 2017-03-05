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
  	assert_kind_of Array, @abortron.create_full_address(100)
  end

  def test_that_full_address_has_needed_fields
  	assert_equal [{:name=>"planned_parenthood_oakland", :address=>"1001 Broadway, Oakland, CA"}, {:name=>"planned_parenthood_san_fran", :address=>"2430 Folsom, San Francisco, CA"}, {:name=>"castro_family_planning", :address=>"517 Castro, San Francisco, CA"}, {:name=>"discreet_treatment_centers_of_ca", :address=>"570 Pacific, Monterey, CA"}, {:name=>"albuquerque_medical_center", :address=>"1801 Mountain NW, Albuquerque, NM"}, {:name=>"butte_health_clinic", :address=>"7473 Humboldt, Butte Meadows, CA"}, {:name=>"womens_health_of_venice_beach", :address=>"2025 Pacific, Los Angeles, CA"}, {:name=>"planned_parenthood_la", :address=>"3900 W Manchester, Los Angeles, CA"}, {:name=>"la_medical_center", :address=>"5905 Wilshire, Los Angeles, CA"}], @abortron.create_full_address(100)
  end

  def test_that_clinic_coordinates_are_hashes
  	addresses = @abortron.create_full_address(100)
  	assert_kind_of Hash, @abortron.clinics_coordinates_conversion
  end

  def test_that_clinic_coordinates_are_found
    @abortron.create_full_address(100)
    information = @abortron.clinics_coordinates_conversion
    assert_equal [37.8021736,-122.2729171], information["planned_parenthood_oakland"]
  end

  def test_that_patient_coordinates_are_found
		pt_address = "88 Colin P Kelly Jr St, San Francisco, CA"
  	pt_mock = MiniTest::Mock.new
  	pt_mock.expect(:ll, [37.78226710000001, -122.3912479])
		Geokit::Geocoders::GoogleGeocoder.stub(:geocode, pt_mock) do
			@abortron.patient_coordinates_conversion(pt_address)
		end
  end

  def test_that_distances_calculated_between_clinics_and_patient
    @abortron.create_full_address(100)
    @abortron.clinics_coordinates_conversion
    @abortron.patient_coordinates_conversion("94117")
    assert_equal [{:name=>"castro_family_planning", :distance=>0.92356303468274}, {:name=>"albuquerque_medical_center", :distance=>896.1457743896646}, {:name=>"butte_health_clinic", :distance=>166.91604621072125}, {:name=>"la_medical_center", :distance=>343.64715401101705}, {:name=>"planned_parenthood_la", :distance=>349.85375580282454}, {:name=>"womens_health_of_venice_beach", :distance=>343.72277289957947}, {:name=>"discreet_treatment_centers_of_ca", :distance=>86.62102600904686}, {:name=>"planned_parenthood_san_fran", :distance=>1.8319683663768311}, {:name=>"planned_parenthood_oakland", :distance=>9.580895789655901}], @abortron.calculate_distance
  end

  def test_that_returns_top_3_closest_clinics
    @abortron.create_full_address(100)
    @abortron.clinics_coordinates_conversion
    @abortron.patient_coordinates_conversion("94117")
    @abortron.calculate_distance
    assert_equal [{:name=>"castro_family_planning", :distance=>0.92356303468274}, {:name=>"albuquerque_medical_center", :distance=>896.1457743896646}, {:name=>"butte_health_clinic", :distance=>166.91604621072125}], @abortron.find_closest_clinics
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
