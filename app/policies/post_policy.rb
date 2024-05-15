class PostPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user.present? && (user_in_same_clan_as_post_author? && (user.admin? || user.trust?))
  end

  def new?
    user.present? && user.admin?
  end

  def create?
    return true if record.new_record?

    new?
  end

  def edit?
    user.present? && user.admin?
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def approve?
    user.present? && user_in_same_clan_as_post_author?
  end

  def disapprove?
    approve?
  end

  private

  def user_in_same_clan_as_post_author?
    user.clans.exists?(id: @record.author.clan_ids)
  end
end
