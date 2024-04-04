class AddApprovalsCountToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :approvals_count, :integer, default: 0, null: false
  end
end
