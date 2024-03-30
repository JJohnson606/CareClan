require 'rails_helper'

RSpec.describe "approvals/edit", type: :view do
  let(:approval) {
    Approval.create!(
      votetype: false,
      voter: nil,
      post: nil,
      approvals_count: 1
    )
  }

  before(:each) do
    assign(:approval, approval)
  end

  it "renders the edit approval form" do
    render

    assert_select "form[action=?][method=?]", approval_path(approval), "post" do

      assert_select "input[name=?]", "approval[votetype]"

      assert_select "input[name=?]", "approval[voter_id]"

      assert_select "input[name=?]", "approval[post_id]"

      assert_select "input[name=?]", "approval[approvals_count]"
    end
  end
end
