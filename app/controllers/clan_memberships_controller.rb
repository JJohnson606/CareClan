# frozen_string_literal: true

class ClanMembershipsController < ApplicationController
  before_action :set_clan_membership, only: %i[show edit update destroy]
  before_action :authorize_admin, only: %i[create destroy]

  def index
    @clan_memberships = ClanMembership.all
  end

  def show; end

  def new
    @clan_membership = ClanMembership.new
  end

  def edit; end

  def create
    @clan_membership = ClanMembership.new(clan_membership_params)
    if @clan_membership.save
      redirect_to @clan_membership, notice: 'Clan membership was successfully created.'
    else
      render :new
    end
  end

  def update
    if @clan_membership.update(clan_membership_params)
      redirect_to @clan_membership, notice: 'Clan membership was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @clan_membership = ClanMembership.find(params[:id])
    @clan_membership.destroy
    redirect_to clan_path(params[:clan_id]), notice: 'Clan membership was successfully destroyed.'
  end

  private

  def set_clan_membership
    @clan_membership = ClanMembership.find(params[:id])
  end

  def clan_membership_params
    params.require(:clan_membership).permit(:clan_id, :user_id, :role)
  end

  def authorize_admin
    return if current_user.admin?

    redirect_to root_path, alert: 'You are not authorized to perform this action.'
  end
end
