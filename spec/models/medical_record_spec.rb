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
require 'rails_helper'

RSpec.describe MedicalRecord, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
