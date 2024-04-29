# frozen_string_literal: true

module RecordTypes
  module ProgressNotesNotes
    def self.permitted_params(params)
      notes_data = {
        date: params[:medical_record][:date],
        note: params[:medical_record][:note]
      }
      notes_data.to_json
    end
  end
end
