# frozen_string_literal: true

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
#  votes_count             :integer          default(0), not null
#
class Comment < ApplicationRecord
  include Votable
  include Ransackable

  # Associations
  belongs_to :post, counter_cache: :comments_count
  belongs_to :author, class_name: 'User'
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_id', dependent: :destroy

  # Counter cache for replies count
  counter_culture :parent, column_name: 'replies_count'

  after_create_commit :enqueue_notification_job

  # Instance methods
  def depth
    parent ? 1 + parent.depth : 0
  end

  private

  def enqueue_notification_job
    NewCommentNotificationJob.perform_later(self)
  end
end

# Reset counter cache for replies_count
Comment.counter_culture_fix_counts column_name: 'replies_count'
