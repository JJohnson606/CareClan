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
#
class Post < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'author_id' # author association
  belongs_to :medical_record, optional: true  # medical record association optional
  has_many :comments, dependent: :destroy # comments association
  acts_as_votable cacheable_strategy: :update_columns # for liking/disliking posts

  
  def approval_rating
    total_votes = self.votes_for.size
    return 0 if total_votes.zero? # To avoid division by zero

    approval_votes = self.get_upvotes.size
    (approval_votes.to_f / total_votes * 100).round(2)
  end
end
