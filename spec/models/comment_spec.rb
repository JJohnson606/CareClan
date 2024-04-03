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
#  parent_id  :uuid
#
require 'rails_helper'

RSpec.describe Comment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
