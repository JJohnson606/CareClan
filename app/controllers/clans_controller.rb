class ClansController < ApplicationController
    before_action :set_clan, only: [:show, :edit, :update, :show_members, :trust_user, :untrust_user]
  
    def index
      @clans = Clan.all
    end
  
    def show
      @clan = Clan.includes(:users).find(params[:id])
      @clan_memberships = @clan.clan_memberships.includes(:user)
    end
  
    def show_members
      @clan = Clan.find(params[:id])
      @members = @clan.users.includes(:profile_picture_attachment).order('name ASC')
    end
  
    def edit
    end
  
    def update
      if @clan.update(clan_params)
        redirect_to @clan, notice: 'Clan was successfully updated.'
      else
        render :edit
      end
    end

    def toggle_trust
        @user = User.find(params[:user_id])
        @user.update(trust: !@user.trust)
        respond_to do |format|
          format.html { redirect_to clan_path(params[:id]), notice: 'Trust status updated.' }
          format.turbo_stream { render turbo_stream: turbo_stream.replace(@user, partial: 'user_row', locals: { user: @user }) }
        end
      end
    
  
    private
  
    def set_clan
      @clan = Clan.find(params[:id])
    end
  
    def clan_params
      params.require(:clan).permit(:name, :description)
    end
  end
  