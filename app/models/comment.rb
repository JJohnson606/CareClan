# app/models/comment.rb
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
  # belongs_to association with Post model
  belongs_to :post
  # belongs_to association with User model, using 'author_id' as foreign key
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
end

