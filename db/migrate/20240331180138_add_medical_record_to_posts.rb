class AddMedicalRecordToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :medical_record_id, :uuid
  end
end
