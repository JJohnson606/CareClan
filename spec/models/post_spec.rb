# == Schema Information
#
# Table name: posts
#
#  id         :uuid             not null, primary key
#  author_id  :uuid
#  body       :text
#  image      :string
#  trusted    :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Post, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
