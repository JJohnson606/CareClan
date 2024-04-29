# frozen_string_literal: true

module RecordTypes
  module SurgicalReportsNotes
    def self.permitted_params(params)
      notes_data = {
        procedure: params[:medical_record][:procedure],
        date: params[:medical_record][:date],
        findings: params[:medical_record][:findings],
        outcome: params[:medical_record][:outcome]
      }
      notes_data.to_json
    end
  end
end
