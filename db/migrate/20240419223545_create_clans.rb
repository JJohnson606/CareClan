class CreateClans < ActiveRecord::Migration[7.0]
  def change
    create_table :clans, id: :uuid do |t|
      t.string :name, null: false
      t.text :description

      t.timestamps
    end

    add_index :clans, :name, unique: true
  end
end
