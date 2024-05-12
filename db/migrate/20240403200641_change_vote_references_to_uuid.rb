class ChangeVoteReferencesToUuid < ActiveRecord::Migration[7.0]
  def change
    # Remove the columns
    remove_column :votes, :votable_id
    remove_column :votes, :voter_id

    # Add the columns back as UUIDs
    add_column :votes, :votable_id, :uuid, index: true
    add_column :votes, :voter_id, :uuid, index: true

    # Add new indexes as necessary
    add_index :votes, %i[votable_id votable_type vote_scope], name: 'index_votes_on_votable_and_scope'
    add_index :votes, %i[voter_id voter_type vote_scope], name: 'index_votes_on_voter_and_scope'
  end
end
