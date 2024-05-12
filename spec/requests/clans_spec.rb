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
require 'rails_helper'

RSpec.describe 'Clans', type: :request do
  describe 'GET /index' do
    pending "add some examples (or delete) #{__FILE__}"
  end
end
