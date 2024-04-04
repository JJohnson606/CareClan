# == Schema Information
#
# Table name: approvals
#
#  id              :uuid             not null, primary key
#  votetype        :boolean
#  voter_id        :uuid             not null
#  post_id         :uuid             not null
#  approvals_count :integer          default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'rails_helper'

RSpec.describe Approval, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
