# frozen_string_literal: true

module RecordTypes
  module LabResultsNotes
    def self.permitted_params(params)
      notes_data = {
        tests: params[:medical_record][:tests].map do |test|
          {
            test_name: test[:test_name],
            result: test[:result],
            reference_range: test[:reference_range],
            comments: test[:comments]
          }
        end
      }
      notes_data.to_json
    end
  end
end
