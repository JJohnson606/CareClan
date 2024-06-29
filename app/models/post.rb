# frozen_string_literal: true

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
class Post < ApplicationRecord
  include Votable
  include Ransackable
  has_one_attached :image
  belongs_to :author, class_name: 'User' # author association
  belongs_to :medical_record, optional: true # medical record association optional
  has_many :comments, dependent: :destroy # comments association
  has_many :noticed_events, as: :record, dependent: :destroy, class_name: 'Noticed::Event'
  has_many :notifications, through: :noticed_events, class_name: 'Noticed::Notification'

  # Counter cache for vote counts
  counter_culture :author, column_name: 'cached_votes_total'
  counter_culture :author, column_name: 'cached_votes_up', delta_column: 'cached_votes_up'
  counter_culture :author, column_name: 'cached_votes_down', delta_column: 'cached_votes_down'
  counter_culture :author, column_name: 'cached_vote_diff', delta_column: 'cached_vote_diff'

  after_create_commit :enqueue_notification_job

  scope :with_author_and_image, -> { includes(:author, image_attachment: :blob) }
  scope :with_comments_and_replies, lambda {
    includes(
      comments: [
        {
          author: {
            profile_picture_attachment: :blob
          }
        },
        {
          replies: [
            :author,
            {
              author: {
                profile_picture_attachment: :blob
              }
            }
          ]
        }
      ]
    )
  }

  scope :controversial, -> { order(cached_vote_diff: :desc) }

  private

  def enqueue_notification_job
    NewPostNotificationJob.perform_later(self)
  end
end
