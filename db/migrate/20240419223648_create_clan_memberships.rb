class CreateClanMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :clan_memberships, id: :uuid do |t|
      t.references :clan, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :role, default: 'member', null: false

      t.timestamps
    end
  end
end
