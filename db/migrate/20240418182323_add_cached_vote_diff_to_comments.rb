class AddCachedVoteDiffToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :cached_vote_diff, :integer, default: 0
  end
end
