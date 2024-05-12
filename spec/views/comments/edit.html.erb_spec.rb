require 'rails_helper'

RSpec.describe 'comments/edit', type: :view do
  let(:comment) do
    Comment.create!(
      body: 'MyText',
      post: nil,
      author: nil
    )
  end

  before(:each) do
    assign(:comment, comment)
  end

  it 'renders the edit comment form' do
    render

    assert_select 'form[action=?][method=?]', comment_path(comment), 'post' do
      assert_select 'textarea[name=?]', 'comment[body]'

      assert_select 'input[name=?]', 'comment[post_id]'

      assert_select 'input[name=?]', 'comment[author_id]'
    end
  end
end
