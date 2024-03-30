require 'rails_helper'

RSpec.describe "medical_records/edit", type: :view do
  let(:medical_record) {
    MedicalRecord.create!(
      patient: nil,
      record_type: "MyString",
      notes: "MyText",
      created_by: nil
    )
  }

  before(:each) do
    assign(:medical_record, medical_record)
  end

  it "renders the edit medical_record form" do
    render

    assert_select "form[action=?][method=?]", medical_record_path(medical_record), "post" do

      assert_select "input[name=?]", "medical_record[patient_id]"

      assert_select "input[name=?]", "medical_record[record_type]"

      assert_select "textarea[name=?]", "medical_record[notes]"

      assert_select "input[name=?]", "medical_record[created_by_id]"
    end
  end
end
