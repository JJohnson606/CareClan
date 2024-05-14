# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit

  helper_method :current_user_can_edit?, :current_user_is_admin?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def current_user_can_edit?(membership)
    current_user == membership.user || current_user_is_admin?(membership.clan)
  end

  def current_user_is_admin?(clan)
    clan.clan_memberships.exists?(user_id: current_user.id, role: 'admin')
  end

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(request.referer || root_path)
  end
end
