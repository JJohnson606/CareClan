# == Schema Information
#
# Table name: posts
#
#  id                      :uuid             not null, primary key
#  author_id               :uuid
#  body                    :text
#  image                   :string
#  trusted                 :boolean
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  approvals_count         :integer          default(0), not null
#  medical_record_id       :uuid
#  cached_votes_total      :integer          default(0)
#  cached_votes_score      :integer          default(0)
#  cached_votes_up         :integer          default(0)
#  cached_votes_down       :integer          default(0)
#  cached_weighted_score   :integer          default(0)
#  cached_weighted_total   :integer          default(0)
#  cached_weighted_average :float            default(0.0)
#  title                   :string
#  cached_vote_diff        :integer          default(0)
#  comments_count          :integer          default(0), not null
#
require 'rails_helper'

RSpec.describe Post, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
