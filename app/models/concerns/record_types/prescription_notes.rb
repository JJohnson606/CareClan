# frozen_string_literal: true

module RecordTypes
  module PrescriptionNotes
    def self.permitted_params(params)
      notes_data = {
        medication_name: params[:medical_record][:medication_name],
        dosage: params[:medical_record][:dosage],
        duration: params[:medical_record][:duration],
        purpose: params[:medical_record][:purpose]
      }
      notes_data.to_json
    end
  end
end
