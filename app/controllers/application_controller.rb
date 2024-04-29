# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user_can_edit?, :current_user_is_admin?

  private

  def current_user_can_edit?(membership)
    current_user == membership.user || current_user_is_admin?(membership.clan)
  end

  def current_user_is_admin?(clan)
    clan.clan_memberships.exists?(user_id: current_user.id, role: 'admin')
  end
end
