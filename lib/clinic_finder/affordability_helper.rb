module ClinicFinder
  module Affordability
    def gestation_to_weeks(gestation)
      (gestation / 7.to_f).ceil
    end

    def add_cost_to_clinic_openstructs(weeks)
      @clinic_structs.each do |clinic|
        clinic.cost = clinic["costs_#{weeks}weeks"]
        # TODO what to do about instances where this isn't set? What should the fallback be?
      end
    end
  end
end
