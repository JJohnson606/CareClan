class AddParentIdToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :parent_id, :uuid
    add_index :comments, :parent_id
  end
end
