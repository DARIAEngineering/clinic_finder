require 'clinic_finder/template'
require 'yaml'
require 'geokit'

# Core class
module Abortron
class ClinicFinder
	attr_reader :clinics

  def initialize(yml_file)
		@clinics = ::YAML.load_file(yml_file)
  end

  def create_full_address(clinic_collection)
    @clinic_addresses = []
    clinic_collection.each do |clinic, info|
      @clinic_addresses << ["#{info['street_address']}, #{info['city']}, #{info['state']}"]
    end
    @clinic_addresses
   # returns an array of string formatted addresses for geocoder method
  end

  def clinics_coordinates_conversion(clinic_addresses)
    @clinic_addresses = clinic_addresses
    @clinic_addresses.map do |address|
      address = address.join 
      location = ::Geokit::Geocoders::GoogleGeocoder.geocode(address)
      location = location.ll
    end
    @clinic_addresses
    # array of arrays of lat/long
  end

  def patient_coordinates_conversion(patient_zipcode)
    @patient_location = ::Geokit::Geocoders::GoogleGeocoder.geocode(patient_zipcode)
    @patient_location = @patient_location.ll
  end

  def calculate_distance
    @distances = []
    @distances = @clinic_addresses.sort_by{|clinic| clinic.distance_to(@patient_location)}
    # returns a list of sorted lat/long from patient address
  end


  def find_closest_clinics
    @distances[0..2]
    # returns closest 3 clinics to the patient
  end

end
end