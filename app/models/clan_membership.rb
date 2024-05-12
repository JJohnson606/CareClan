# == Schema Information
#
# Table name: clan_memberships
#
#  id         :uuid             not null, primary key
#  clan_id    :uuid             not null
#  user_id    :uuid             not null
#  role       :string           default("member"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ClanMembership < ApplicationRecord
  belongs_to :clan
  belongs_to :user
end
