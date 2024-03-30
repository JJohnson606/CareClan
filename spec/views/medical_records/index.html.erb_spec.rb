require 'rails_helper'

RSpec.describe "medical_records/index", type: :view do
  before(:each) do
    assign(:medical_records, [
      MedicalRecord.create!(
        patient: nil,
        record_type: "Record Type",
        notes: "MyText",
        created_by: nil
      ),
      MedicalRecord.create!(
        patient: nil,
        record_type: "Record Type",
        notes: "MyText",
        created_by: nil
      )
    ])
  end

  it "renders a list of medical_records" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Record Type".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
