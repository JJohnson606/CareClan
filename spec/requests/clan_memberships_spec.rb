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
require 'rails_helper'

RSpec.describe 'ClanMemberships', type: :request do
  describe 'GET /index' do
    pending "add some examples (or delete) #{__FILE__}"
  end
end
