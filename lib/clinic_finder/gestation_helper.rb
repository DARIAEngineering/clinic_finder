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

      # gestational_hash = {9: "costs_9wks",
      #                     }

      # week_increments = gestational_hash.keys.map(&:to_i).push(@gestational_weeks).sort

      # patient_position = week_increments.index(@gestational_weeks)

      # increment = patient_position == 0 ? week_increments[1] : week_increments[patient_position - 1]

      # gestational_tier = gestational_hash[increment.to_s]
      # return gestational_tier.to_s
    # end

    def within_gestational_limit?(gestational_limit)
      @gestational_age < gestational_limit
    end




    # .initialize - take days; @days
    # #to_weeks - convert days to weeks
    #

    # #price_at_gestation(clinic_hash) - spit out cost of procedure based on @days attribute on instance
  end
end
