class ChangeVoterIdToUuidInVotes < ActiveRecord::Migration[7.0]
  def change
    # Assuming the existing voter_id column is of type :integer or :bigint
    remove_column :votes, :voter_id, :bigint

    # Adding the voter_id column back as :uuid
    add_column :votes, :voter_id, :uuid
    add_index :votes, :voter_id
  end
end
