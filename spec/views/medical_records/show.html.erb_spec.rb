require 'rails_helper'

RSpec.describe 'medical_records/show', type: :view do
  before(:each) do
    assign(:medical_record, MedicalRecord.create!(
                              patient: nil,
                              record_type: 'Record Type',
                              notes: 'MyText',
                              created_by: nil
                            ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Record Type/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
