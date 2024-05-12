# == Schema Information
#
# Table name: clans
#
#  id          :uuid             not null, primary key
#  name        :string           not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Clan < ApplicationRecord
  has_many :clan_memberships
  has_many :users, through: :clan_memberships
  has_many :posts, through: :users
  has_many :medical_records, through: :users
end
