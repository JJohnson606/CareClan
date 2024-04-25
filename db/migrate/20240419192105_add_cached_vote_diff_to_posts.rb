class AddCachedVoteDiffToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :cached_vote_diff, :integer, default: 0
  end
end
