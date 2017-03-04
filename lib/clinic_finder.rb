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
    clinic_collection.each do |clinic|
      clinic_addresses << ["#{clinic[:street_address]}, #{clinic[:city]}, #{clinic[:state]}"]
    end
    clinic_addresses
   # returns an array of string formatted addresses for geocoder method
  end


end

