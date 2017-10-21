require 'minitest/autorun'
require 'minitest/spec'
require 'clinic_finder'
require 'yaml'
require 'ostruct'

# Convenience methods and the base test class
class TestClass < MiniTest::Test
  def load_clinic_fixtures
    clinics = File.load_file File.join(File.dirname(__FILE__),
                                       './fixtures/clinics.yml')
    clinics.keys.map { |name| OpenStruct.new clinics[name] }
  end
end
