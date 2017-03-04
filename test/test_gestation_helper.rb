require 'test_helper'
require_relative '../lib/clinic_finder/gestation_helper'

class TestGestationHelper < TestClass
  def setup
    @helper = ClinicFinder::GestationHelper.new(10)
  end

  def test_that_initialize_sets_gestational_age_variable
    assert_equal 10, @helper.gestational_age
  end

  def test_that_gestational_limit_greater_than_ga_is_true
    assert_equal true, @helper.within_gestational_limit?(30)
  end

  def test_that_gestational_limit_less_than_ga_is_false
    assert_equal false, @helper.within_gestational_limit?(5)
  end

  def test_that_gestational_limit_equal_to_ga_is_false
    assert_equal false, @helper.within_gestational_limit?(10)
  end
end
