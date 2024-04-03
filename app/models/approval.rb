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
class Approval < ApplicationRecord
  belongs_to :voter, class_name: 'User', foreign_key: 'voter_id'
  belongs_to :post, counter_cache: true
end
