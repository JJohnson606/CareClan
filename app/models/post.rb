# == Schema Information
#
# Table name: posts
#
#  id              :uuid             not null, primary key
#  author_id       :uuid
#  body            :text
#  image           :string
#  trusted         :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  approvals_count :integer          default(0), not null
#
class Post < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'author_id' # author association
  has_many :comments, dependent: :destroy # comments association
  has_many :approvals, dependent: :destroy # approvals association
end
