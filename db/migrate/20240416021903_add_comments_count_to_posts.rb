class AddCommentsCountToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :comments_count, :integer, default: 0, null: false
   
    Post.reset_column_information
    Post.find_each do |post|
      post.update(comments_count: post.comments.count)
    end
  end
end