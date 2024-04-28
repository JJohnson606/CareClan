# app/models/concerns/votable.rb
module Votable
  extend ActiveSupport::Concern

  included do
    acts_as_votable cacheable_strategy: :update_columns

    def approval_rating
      total_votes = votes_for.size
      return 0 if total_votes.zero?
      approval_votes = get_upvotes.size
      (approval_votes.to_f / total_votes * 100).round(2)
    end
  end
end
