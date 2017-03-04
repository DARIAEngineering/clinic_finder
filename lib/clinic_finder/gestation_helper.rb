class ClinicFinder
  class GestationHelper
    attr_reader :gestational_age

    def initialize(gestational_age)
      @gestational_age = gestational_age
    end

    def gestation_in_weeks
      (@gestational_age/7.0).ceil
    end

    def price_at_gestation(clinic_hash)


    end

    def within_gestational_limit?(gestational_limit)
      @gestational_age < gestational_limit
    end




    # .initialize - take days; @days
    # #to_weeks - convert days to weeks
    #

    # #price_at_gestation(clinic_hash) - spit out cost of procedure based on @days attribute on instance
  end
end
