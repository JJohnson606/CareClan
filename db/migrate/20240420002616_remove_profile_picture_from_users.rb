class RemoveProfilePictureFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :profile_picture, :string
  end
end
