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
require 'rails_helper'

RSpec.describe CommentsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/comments').to route_to('comments#index')
    end

    it 'routes to #new' do
      expect(get: '/comments/new').to route_to('comments#new')
    end

    it 'routes to #show' do
      expect(get: '/comments/1').to route_to('comments#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/comments/1/edit').to route_to('comments#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/comments').to route_to('comments#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/comments/1').to route_to('comments#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/comments/1').to route_to('comments#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/comments/1').to route_to('comments#destroy', id: '1')
    end
  end
end
