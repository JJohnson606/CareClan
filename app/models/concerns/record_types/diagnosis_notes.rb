# frozen_string_literal: true

module RecordTypes
  module DiagnosisNotes
    def self.permitted_params(params)
      notes_data = {
        condition: params[:medical_record][:condition],
        symptoms: params[:medical_record][:symptoms],
        recommended_treatment: params[:medical_record][:recommended_treatment]
      }
      notes_data.to_json
    end
  end
end
