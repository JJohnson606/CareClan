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
  has_one_attached :image
  belongs_to :author, class_name: 'User', foreign_key: 'author_id' # author association
  belongs_to :medical_record, optional: true  # medical record association optional
  has_many :comments, dependent: :destroy # comments association
  has_many :noticed_events, as: :record, dependent: :destroy, class_name: "Noticed::Event"
  has_many :notifications, through: :noticed_events, class_name: "Noticed::Notification"


  # Defined which attributes are searchable/sortable with Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[title created_at comments_count cached_votes_up cached_votes_down cached_vote_diff]
  end

  # Defined which associations should be searchable
  def self.ransackable_associations(auth_object = nil)
    %w[author comments]
  end


  def voters_up
    User.joins(:votes).where(votes: { votable: self, vote_flag: true }).includes(:profile_picture_attachment)
  end

  def voters_down
    User.joins(:votes).where(votes: { votable: self, vote_flag: false }).includes(:profile_picture_attachment)
  end

  scope :controversial, -> { order(cached_vote_diff: :desc) }
end
