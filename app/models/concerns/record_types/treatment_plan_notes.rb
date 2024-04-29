# frozen_string_literal: true

module RecordTypes
  module TreatmentPlanNotes
    def self.permitted_params(params)
      notes_data = {
        treatment: params[:medical_record][:treatment],
        duration: params[:medical_record][:duration],
        follow_up: params[:medical_record][:follow_up]
      }
      notes_data.to_json
    end
  end
end
