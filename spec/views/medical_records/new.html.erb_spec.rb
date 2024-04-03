require 'rails_helper'

RSpec.describe "medical_records/new", type: :view do
  before(:each) do
    assign(:medical_record, MedicalRecord.new(
      patient: nil,
      record_type: "MyString",
      notes: "MyText",
      created_by: nil
    ))
  end

  it "renders new medical_record form" do
    render

    assert_select "form[action=?][method=?]", medical_records_path, "post" do

      assert_select "input[name=?]", "medical_record[patient_id]"

      assert_select "input[name=?]", "medical_record[record_type]"

      assert_select "textarea[name=?]", "medical_record[notes]"

      assert_select "input[name=?]", "medical_record[created_by_id]"
    end
  end
end
