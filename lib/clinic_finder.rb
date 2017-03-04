require 'clinic_finder/template'

# Core class
module ClinicFinder
  def self.hello_world
    puts 'hello world'
  end

  # goal: convert each address object into coordinates
  # in: clinic collection (array of hashes)
  # for each clinic object: take street address, city, state (concat to make address)
    # output: 1001 Brodway Oakland, CA
  # pass ^ geocoder to find lat/long
    # output: array of lat/long

  def create_full_address(clinic_collection)
    clinic_addresses = []
    clinic_collection.each do |clinic, info|
      clinic_addresses << ["#{info[:street_address]}, #{info[:city]}, #{info[:state]}"]
    end
    clinic_addresses
   # returns an array of string formatted addresses for geocoder method
  end

  # goal: finding the closest clinic to our patient
  # in: patient address
  # use geocoder
  def find_closest_clinic(clinic_collection, patient_address, radius)
    create_full_address(clinic_collection)


  end

end











