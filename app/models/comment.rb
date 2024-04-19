# app/models/comment.rb
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
#
class Comment < ApplicationRecord
  acts_as_votable

  # Associations
  belongs_to :post, counter_cache: true
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :parent, class_name: 'Comment', optional: true, counter_cache: :replies_count
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_id', dependent: :destroy

  # Callbacks
  after_save :update_vote_cache


    # Defined which attributes are searchable/sortable with Ransack
    def self.ransackable_attributes(auth_object = nil)
      %w[created_at replies_count cached_votes_up cached_votes_down cached_vote_diff cached_votes_total]
    end
  
    # Attributes that should not be searchable
    def self.ransackable_associations(auth_object = nil)
      []
    end
  
  # Instance methods
  def depth
    parent ? 1 + parent.depth : 0
  end

  def approval_rating
    total_votes = votes_for.size
    return 0 if total_votes.zero?

    approval_votes = get_upvotes.size
    (approval_votes.to_f / total_votes * 100).round(2)
  end

  def update_vote_cache
    upvotes = get_upvotes.size
    downvotes = get_downvotes.size
    total_votes = upvotes + downvotes
    vote_diff = (upvotes - downvotes).abs

    update_columns(
      cached_votes_up: upvotes,
      cached_votes_down: downvotes,
      cached_votes_total: total_votes,
      cached_vote_diff: vote_diff
    )
  end
end