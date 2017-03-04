require 'clinic_finder/template'

# Core class
module ClinicFinder
  def self.hello_world
    puts 'hello world'
  end


  def create_full_address(clinic_collection)
    @clinic_addresses = []
    clinic_collection.each do |clinic, info|
      @clinic_addresses << ["#{info[:street_address]}, #{info[:city]}, #{info[:state]}"]
    end
    @clinic_addresses
   # returns an array of string formatted addresses for geocoder method
  end

  def clinics_coordinates_conversion(clinic_addresses)
    @clinic_addresses.map do |address|
      location = Geokit::Geocoders::GoogleGeocoder.geocode(address)
      location = location.ll
    end
    @clinic_addresses
    # array of arrays of lat/long
  end

  def patient_coordinates_conversion(patient_address)
    @patient_location = Geokit::Geocoders::GoogleGeocoder.geocode(patient_address)
    @patient_location = @patient_location.ll
  end

  def calculate_distance(patient_address)
    @distances = []
    @distances = @clinic_addresses.sort_by{|clinic| clinic.distance_to(@patient_location)}
    # returns a list of sorted lat/long from patient address
  end


  def find_closest_clinics(patient_address)
    @distances[0..2]
    # returns closest 3 clinics to the patient
  end

end