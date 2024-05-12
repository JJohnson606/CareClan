require 'rails_helper'

RSpec.describe 'approvals/index', type: :view do
  before(:each) do
    assign(:approvals, [
             Approval.create!(
               votetype: false,
               voter: nil,
               post: nil,
               approvals_count: 2
             ),
             Approval.create!(
               votetype: false,
               voter: nil,
               post: nil,
               approvals_count: 2
             )
           ])
  end

  it 'renders a list of approvals' do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
  end
end
