# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :integer
#  profile_picture        :string
#  trust                  :boolean
#  name                   :string
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :posts, foreign_key: 'author_id', dependent: :destroy
  has_many :comments, foreign_key: 'author_id', dependent: :destroy
  has_many :medical_records_as_patient, foreign_key: 'patient_id', class_name: 'MedicalRecord', dependent: :destroy
  has_many :medical_records_as_creator, foreign_key: 'created_by_id', class_name: 'MedicalRecord', dependent: :destroy
  enum role: { patient: 0, healthcare_proffesional: 1, clan_poa: 2, clan_non_poa: 3 }
end
