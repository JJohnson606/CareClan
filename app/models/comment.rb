# == Schema Information
#
# Table name: comments
#
#  id         :uuid             not null, primary key
#  body       :text
#  post_id    :uuid             not null
#  author_id  :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
end

