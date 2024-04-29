# frozen_string_literal: true

module RecordTypes
  module ImagingNotes
    def self.permitted_params(params)
      notes_data = {
        type: params[:medical_record][:type],
        findings: params[:medical_record][:findings],
        interpretation: params[:medical_record][:interpretation]
      }
      notes_data.to_json
    end
  end
end
