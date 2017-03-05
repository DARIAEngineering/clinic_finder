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
  	assert_kind_of Array, @abortron.create_full_address
  end

  def test_that_full_address_has_needed_fields
  	assert_equal [{:name=>"planned_parenthood_oakland", :address=>"1001 Broadway, Oakland, CA"}, {:name=>"planned_parenthood_san_fran", :address=>"2430 Folsom, San Francisco, CA"}, {:name=>"castro_family_planning", :address=>"517 Castro, San Francisco, CA"}, {:name=>"silcon_valley_womens_clinic", :address=>"110 S Market, San Jose, CA"}, {:name=>"discreet_treatment_centers_of_ca", :address=>"570 Pacific, Monterey, CA"}, {:name=>"albuquerque_medical_center", :address=>"1801 Mountain NW, Albuquerque, NM"}, {:name=>"butte_health_clinic", :address=>"7473 Humboldt, Butte Meadows, CA"}, {:name=>"planned_parenthood_fresno", :address=>"2220 Tulare, Fresno, CA"}, {:name=>"womens_health_of_venice_beach", :address=>"2025 Pacific, Los Angeles, CA"}, {:name=>"planned_parenthood_la", :address=>"3900 W Manchester, Los Angeles, CA"}, {:name=>"la_medical_center", :address=>"5905 Wilshire, Los Angeles, CA"}], @abortron.create_full_address
  end

  def test_that_clinic_coordinates_are_array
  	addresses = @abortron.create_full_address
  	assert_kind_of Hash, @abortron.clinics_coordinates_conversion
  end

  # def test_that_clinic_coordinates_are_found
  # 	# addresses = [["1001 Broadway, Oakland, CA"], ["2430 Folsom, San Francisco, CA"], ["517 Castro, San Francisco, CA"]]
  # 	# ouput = [["37.8021736, -122.2729171"], ["37.758278,-122.415025"], ["37.7605162,-122.4347025"]]
  # 	mock = MiniTest::Mock.new
  # 	mock.expect(:ll, ["37.8021736, -122.2729171"])
		# Geokit::Geocoders::MultiGeocoder.stub(:geocode, mock) do
		# 	@abortron.clinics_coordinates_conversion
		# end
  # end

  def test_that_patient_coordinates_are_found
		pt_address = "88 Colin P Kelly Jr St, San Francisco, CA"
  	pt_mock = MiniTest::Mock.new
  	pt_mock.expect(:ll, [37.78226710000001, -122.3912479])
		Geokit::Geocoders::MultiGeocoder.stub(:geocode, pt_mock) do
			@abortron.patient_coordinates_conversion(pt_address)
		end
  end

  def test_that_distances_calculated_between_clinics_and_patient
    coords_hash = {
      "Oakland" => {name: "Oakland", coordinates: [37.8021736,  -122.2729171]},
      "San Francisco" => {name: "San Francisco", coordinates: [37.758278, -122.415025]}
    }
    patient = ["37.7605162,-122.4347025"]
    distance_mock = MiniTest::Mock.new
    distance_mock.expect(:ll, [37.7605162,-122.4347025])
    Geokit::Geocoders::MultiGeocoder.stub(:distance_to, distance_mock) do
      @abortron.calculate_distance(coords_hash, patient)
    end
    # assert_equal [
    #   {name: "San Francisco", distance: 1.087156200012801}, {name: "Oakland", distance: 9.302242978400399}], @abortron.calculate_distance(coords_hash, patient)
  end

  def test_that_returns_top_3_closest_clinics
    coords_hash = {
      "Oakland" => {name: "Oakland", coordinates: [37.8021736,  -122.2729171]},
      "San Francisco" => {name: "San Francisco", coordinates: [37.758278, -122.415025]}
    }

    patient = [37.7605162,-122.4347025]

    @abortron.calculate_distance(coords_hash, patient)

    # distances = [{name: "San Francisco", distance: 1.087156200012801}, {name: "Oakland", distance: 9.302242978400399}, {name: "San Francisco", distance: 1.087156200012801}, {name: "Oakland", distance: 9.302242978400399}]

    assert_equal [{name: "San Francisco", distance: 1.087156200012801}, {name: "Oakland", distance: 9.302242978400399}], @abortron.find_closest_clinics
  end

end
