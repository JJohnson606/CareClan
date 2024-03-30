require 'rails_helper'

RSpec.describe "approvals/show", type: :view do
  before(:each) do
    assign(:approval, Approval.create!(
      votetype: false,
      voter: nil,
      post: nil,
      approvals_count: 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/false/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
  end
end
