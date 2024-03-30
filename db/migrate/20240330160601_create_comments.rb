class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments, id: :uuid do |t|
      t.text :body
      t.references :post, null: false, foreign_key: { to_table: :posts }, type: :uuid
      # Specify the table for the author reference
      t.references :author, null: false, foreign_key: { to_table: :users }, type: :uuid

      t.timestamps
    end
  end
end
