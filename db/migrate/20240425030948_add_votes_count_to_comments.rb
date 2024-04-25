class AddVotesCountToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :votes_count, :integer, default: 0, null: false

   
    Comment.reset_column_information
    Comment.find_each do |comment|
      Comment.update_counters comment.id, votes_count: comment.get_upvotes.size + comment.get_downvotes.size
    end
  end
end
