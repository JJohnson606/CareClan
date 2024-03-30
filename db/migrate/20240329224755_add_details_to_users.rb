class AddDetailsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :role, :integer
    add_column :users, :profile_picture, :string
    add_column :users, :trust, :boolean
  end
end
