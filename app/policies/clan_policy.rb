# frozen_string_literal: true

class ClanPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user.present? && (
      (record.clan_memberships.exists?(user_id: user.id) && (user.patient? || user.admin? || user.clan_poa?)) ||
      record.clan_memberships.exists?(user_id: user.id, role: 'admin')
    )
  end

  def create?
    user.present? && (user.patient? || user.admin? || user.clan_poa?)
  end

  def update?
    user.present? && (
      (record.clan_memberships.exists?(user_id: user.id) && (user.patient? || user.admin? || user.clan_poa?)) ||
      record.clan_memberships.exists?(user_id: user.id, role: 'admin')
    )
  end

  def destroy?
    update?
  end

  def show_members?
    user.present? && (record.users.include?(user) || user.admin?)
  end

  def toggle_trust?
    user.present? && (
      (record.clan_memberships.exists?(user_id: user.id) && (user.patient? || user.admin? || user.clan_poa?)) ||
      record.clan_memberships.exists?(user_id: user.id, role: 'admin')
    )
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
