class CreateApprovals < ActiveRecord::Migration[7.0]
  def change
    create_table :approvals, id: :uuid do |t|
      t.boolean :votetype
      t.references :voter, type: :uuid, null: false, foreign_key: { to_table: :users } # Assuming 'voter' references 'users'
      t.references :post, type: :uuid, null: false, foreign_key: true
      t.integer :approvals_count, default: 0 # Setting a default value if necessary

      t.timestamps
    end

    # Optionally, add an index to ensure a user can only vote once per post
    add_index :approvals, %i[voter_id post_id], unique: true
  end
end
