require 'rails_helper'

RSpec.describe 'approvals/new', type: :view do
  before(:each) do
    assign(:approval, Approval.new(
                        votetype: false,
                        voter: nil,
                        post: nil,
                        approvals_count: 1
                      ))
  end

  it 'renders new approval form' do
    render

    assert_select 'form[action=?][method=?]', approvals_path, 'post' do
      assert_select 'input[name=?]', 'approval[votetype]'

      assert_select 'input[name=?]', 'approval[voter_id]'

      assert_select 'input[name=?]', 'approval[post_id]'

      assert_select 'input[name=?]', 'approval[approvals_count]'
    end
  end
end
