# == Schema Information
#
# Table name: comments
#
#  id                      :uuid             not null, primary key
#  body                    :text
#  post_id                 :uuid             not null
#  author_id               :uuid             not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  parent_id               :uuid
#  replies_count           :integer          default(0), not null
#  cached_votes_total      :integer          default(0), not null
#  cached_votes_score      :integer          default(0), not null
#  cached_votes_up         :integer          default(0), not null
#  cached_votes_down       :integer          default(0), not null
#  cached_weighted_score   :integer          default(0), not null
#  cached_weighted_total   :integer          default(0), not null
#  cached_weighted_average :float            default(0.0), not null
#  cached_vote_diff        :integer          default(0)
#  votes_count             :integer          default(0), not null
#
require 'rails_helper'

RSpec.describe Comment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
