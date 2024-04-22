class AddVoteCachingToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :cached_votes_total, :integer, default: 0, null: false
    add_column :comments, :cached_votes_score, :integer, default: 0, null: false
    add_column :comments, :cached_votes_up, :integer, default: 0, null: false
    add_column :comments, :cached_votes_down, :integer, default: 0, null: false
    add_column :comments, :cached_weighted_score, :integer, default: 0, null: false
    add_column :comments, :cached_weighted_total, :integer, default: 0, null: false
    add_column :comments, :cached_weighted_average, :float, default: 0.0, null: false
  end
end
