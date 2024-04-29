# app/models/concerns/ransackable.rb
module Ransackable
  extend ActiveSupport::Concern

  included do
    def self.ransackable_attributes(auth_object = nil)
      case self.name
      when 'Post'
        %w[title created_at comments_count cached_votes_up cached_votes_down cached_vote_diff]
      when 'Comment'
        %w[created_at replies_count cached_votes_up cached_votes_down cached_vote_diff cached_votes_total]
      else
        []
      end
    end

    def self.ransackable_associations(auth_object = nil)
      case self.name
      when 'Post'
        %w[author comments]
      else
        []
      end
    end
  end
end
