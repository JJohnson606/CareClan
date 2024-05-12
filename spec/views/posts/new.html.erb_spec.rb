require 'rails_helper'

RSpec.describe 'posts/new', type: :view do
  before(:each) do
    assign(:post, Post.new(
                    author: nil,
                    body: 'MyText',
                    image: 'MyString',
                    trusted: false
                  ))
  end

  it 'renders new post form' do
    render

    assert_select 'form[action=?][method=?]', posts_path, 'post' do
      assert_select 'input[name=?]', 'post[author_id]'

      assert_select 'textarea[name=?]', 'post[body]'

      assert_select 'input[name=?]', 'post[image]'

      assert_select 'input[name=?]', 'post[trusted]'
    end
  end
end
