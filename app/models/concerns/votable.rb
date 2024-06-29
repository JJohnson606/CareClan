# app/models/concerns/votable.rb
# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern

  included do
    acts_as_votable

    def voters_up
      User.joins(:votes).where(votes: { votable: self, vote_flag: true }).includes(:profile_picture_attachment)
    end

    def voters_down
      User.joins(:votes).where(votes: { votable: self, vote_flag: false }).includes(:profile_picture_attachment)
    end

    def upvotes_count
      get_upvotes.size
    end

    def downvotes_count
      get_downvotes.size
    end

    def approval_rating
      total_votes = votes_for.size
      return 0 if total_votes.zero?

      approval_votes = get_upvotes.size
      (approval_votes.to_f / total_votes * 100).to_i
    end
  end
end
