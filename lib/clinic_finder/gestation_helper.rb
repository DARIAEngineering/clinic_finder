class ClinicFinder
  class GestationHelper
    attr_reader :gestational_age, :gestational_weeks

    def initialize(gestational_age)
      @gestational_age = gestational_age
      @gestational_weeks = (@gestational_age/7.0).ceil
    end

    def gestational_tier
      if @gestational_weeks < 10
        'costs_9wks'
      elsif @gestational_weeks < 13
        'costs_12wks'
      elsif @gestational_weeks < 19
        'costs_18wks'
      elsif @gestational_weeks < 25
        'costs_24wks'
      else
        'costs_30wks'
      end
    end

    def within_gestational_limit?(gestational_limit)
      @gestational_age < gestational_limit
    end
  end
end
