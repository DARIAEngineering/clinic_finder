class ClinicFinder
  class GestationHelper
    attr_reader :gestational_age, :gestational_weeks

    def initialize(gestational_age)
      @gestational_age = gestational_age
      @gestational_weeks = (@gestational_age/7.0).ceil
    end

    def gestational_tier(clinic_attributes)
      gestational_hash = {}

      clinic_attributes.each do |key, value|
        if key.to_s[/\d+/]
          gestational_hash[(key.to_s[/\d+/])] = key
        end
      end

      week_tiers = gestational_hash.keys.map(&:to_i)

      week_tiers << @gestational_weeks
      week_tiers.sort!

      current_position = week_tiers.index(@gestational_weeks)


      numerical_term = current_position == 0 ? week_tiers[1] : week_tiers[current_position - 1]

      gestational_tier = gestational_hash[numerical_term.to_s]
      return gestational_tier.to_s
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
