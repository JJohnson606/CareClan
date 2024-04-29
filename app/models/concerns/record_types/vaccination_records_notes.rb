# frozen_string_literal: true

module RecordTypes
  module VaccinationRecordsNotes
    def self.permitted_params(params)
      notes_data = {
        vaccine: params[:medical_record][:vaccine],
        date: params[:medical_record][:date],
        lot_number: params[:medical_record][:lot_number],
        site: params[:medical_record][:site]
      }
      notes_data.to_json
    end
  end
end
