class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts, id: :uuid do |t|
      t.references :author, type: :uuid, foreign_key: { to_table: :users }
      t.text :body
      t.string :image
      t.boolean :trusted

      t.timestamps
    end
  end
end
