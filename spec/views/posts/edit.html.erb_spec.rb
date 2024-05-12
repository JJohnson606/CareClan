require 'rails_helper'

RSpec.describe 'posts/edit', type: :view do
  let(:post) do
    Post.create!(
      author: nil,
      body: 'MyText',
      image: 'MyString',
      trusted: false
    )
  end

  before(:each) do
    assign(:post, post)
  end

  it 'renders the edit post form' do
    render

    assert_select 'form[action=?][method=?]', post_path(post), 'post' do
      assert_select 'input[name=?]', 'post[author_id]'

      assert_select 'textarea[name=?]', 'post[body]'

      assert_select 'input[name=?]', 'post[image]'

      assert_select 'input[name=?]', 'post[trusted]'
    end
  end
end
