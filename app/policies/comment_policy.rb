# frozen_string_literal: true

class CommentPolicy < ApplicationPolicy
  def index?
    user.present? && user_in_same_clan_as_post_author?
  end

  def show?
    user.present? && user_in_same_clan_as_post_author?
  end

  def create?
    user.present? && user_in_same_clan_as_post_author? && user.trust?
  end

  def update?
    user.present? && (user == record.author)
  end

  def destroy?
    user.present? && (user == record.author)
  end

  def approve?
    user.present? && user_in_same_clan_as_post_author? && user.trust?
  end

  def disapprove?
    user.present? && user_in_same_clan_as_post_author? && user.trust?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private

  def user_in_same_clan_as_post_author?
    post = record.post || record.parent&.post
    post.present? && user.clans.exists?(id: post.author.clan_ids)
  end
end
