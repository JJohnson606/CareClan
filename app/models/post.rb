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
#  comments_count          :integer          default(0), not null
#  cached_vote_diff        :integer          default(0)
#
class Post < ApplicationRecord
  has_one_attached :image
  belongs_to :author, class_name: 'User', foreign_key: 'author_id' # author association
  belongs_to :medical_record, optional: true  # medical record association optional
  has_many :comments, dependent: :destroy # comments association
  has_many :noticed_events, as: :record, dependent: :destroy, class_name: "Noticed::Event"
  has_many :notifications, through: :noticed_events, class_name: "Noticed::Notification"
  acts_as_votable cacheable_strategy: :update_columns # for liking/disliking posts

  # Defined which attributes are searchable/sortable with Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[title created_at comments_count cached_votes_up cached_votes_down cached_vote_diff]
  end

  # Defined which associations should be searchable
  def self.ransackable_associations(auth_object = nil)
    %w[author comments]
  end
 
  
  def approval_rating
    total_votes = self.votes_for.size
    return 0 if total_votes.zero? # To avoid division by zero

    approval_votes = self.get_upvotes.size
    (approval_votes.to_f / total_votes * 100).round(2)
  end

  scope :controversial, -> { order(cached_vote_diff: :desc) }
end

