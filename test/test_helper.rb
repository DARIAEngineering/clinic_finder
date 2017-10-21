require 'minitest/autorun'
require 'clinic_finder'

class TestClass < MiniTest::Test
  def load_clinic_fixtures
    file = File.join(File.dirname(__FILE__), '../fixtures/clinics.yml')
  end
end
