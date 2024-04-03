# == Schema Information
#
# Table name: medical_records
#
#  id            :uuid             not null, primary key
#  patient_id    :uuid             not null
#  record_type   :string
#  record_date   :date
#  notes         :text
#  created_by_id :uuid             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class MedicalRecord < ApplicationRecord
   belongs_to :patient, class_name: 'User', foreign_key: 'patient_id'
   belongs_to :creator, class_name: 'User', foreign_key: 'created_by_id'
 end
  
