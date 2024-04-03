class CreateMedicalRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :medical_records, id: :uuid do |t|
      
      t.references :patient, type: :uuid, null: false, foreign_key: { to_table: :users }
      
      t.string :record_type
      t.date :record_date
      t.text :notes
      
      t.references :created_by, type: :uuid, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end

