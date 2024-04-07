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
  acts_as_voter # for liking/disliking posts
 # Associations common for all users
 has_many :posts, foreign_key: 'author_id', dependent: :destroy
 has_many :comments, foreign_key: 'author_id', dependent: :destroy

 # Associations specific to medical patients
 has_many :medical_records_as_patient, foreign_key: 'patient_id', class_name: 'MedicalRecord', dependent: :destroy
 belongs_to :healthcare_provider, class_name: 'User', optional: true # Assuming healthcare providers are also users

 # Associations specific to healthcare professionals
 has_many :patients, class_name: 'User', foreign_key: 'healthcare_provider_id'
 has_many :medical_records_as_creator, foreign_key: 'created_by_id', class_name: 'MedicalRecord', dependent: :destroy

 # Enum for role to distinguish between different types of users
 enum role: { patient: 0, healthcare_professional: 1, clan_poa: 2, clan_non_poa: 3, family_friend: 4 }
 # Added scope for patients
 scope :patients, -> { where(role: :patient) }
 # Added scope for healthcare professionals
 scope :healthcare_professionals, -> { where(role: :healthcare_professional) }
 
 # Validations
 # TODO: Add validation for email format
 # TODO: Add validation for age


 # User attributes
 # Common attributes
 #TODO Add a name sub-attribute for prefix, first_name, middle_initial, last_name, suffix.
 attribute :profile_picture, :string
 attribute :date_of_birth, :date
 attribute :phone_number, :string
 attribute :trust, :boolean, default: false

 # Patient-specific attributes
 attribute :medical_conditions, :text
 attribute :emergency_contact, :string # Could be a phone number or an association to another user
 
 # Healthcare professional-specific attributes
 attribute :professional_license, :string
 attribute :specialization, :string
 attribute :work_institution, :string
 attribute :availability, :boolean, default: true

 # Family friend-specific attributes
 attribute :relationship_to_patient, :string
 attribute :interests, :text # Could be serialized or linked to an interests table

end
