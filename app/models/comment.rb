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
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :parent, class_name: 'Comment', optional: true, counter_cache: :replies_count
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_id', dependent: :destroy

  after_create_commit :notify_new_comment

  # Instance methods
  def depth
    parent ? 1 + parent.depth : 0
  end

  private

  def notify_new_comment
    NewCommentNotifier.with(post: post, user: author, message: body).deliver_later
  end
end
