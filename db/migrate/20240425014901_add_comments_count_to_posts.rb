class AddCommentsCountToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :comments_count, :integer, default: 0, null: false

    # Ensuring the model is aware of new column
    Post.reset_column_information

    # Update comments_count without triggering ActiveRecord callbacks
    Post.find_each do |post|
      Post.update_counters post.id, comments_count: post.comments.length
    end
  end
end
