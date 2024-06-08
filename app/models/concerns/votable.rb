# app/models/concerns/votable.rb
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

    def update_vote_cache
      upvotes = get_upvotes.size
      downvotes = get_downvotes.size
      total_votes = upvotes + downvotes
      vote_diff = (upvotes - downvotes).abs

      update_columns(
        cached_votes_up: upvotes,
        cached_votes_down: downvotes,
        cached_votes_total: total_votes,
        cached_vote_diff: vote_diff
      )
    end

    def approval_rating
      total_votes = votes_for.size
      return 0 if total_votes.zero?

      approval_votes = get_upvotes.size
      (approval_votes.to_f / total_votes * 100).to_i
    end

    private

    def update_vote_cache_after_vote
      after_save :update_vote_cache_after_vote, if: :saved_change_to_votes?
    end
  end
end
