class AddRelationshipToPatientToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :relationship_to_patient, :string
  end
end
