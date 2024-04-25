class ClansController < ApplicationController
    before_action :set_clan, only: [:show, :edit, :update, :destroy, :show_members, :trust_user, :untrust_user]
  
    def index
      @clans = Clan.all
    end
  
    def show
      @clan = Clan.includes(:users).find(params[:id])
      @clan_memberships = @clan.clan_memberships.includes(:user)
                         .sort_by { |membership| membership.user.role == "admin" ? 0 : 1 }
    end
  
    def show_members
      @clan = Clan.find(params[:id])
      @members = @clan.users.includes(:profile_picture_attachment)
                           .sort_by { |user| user.role == "admin" ? 0 : 1 }
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

    def destroy
        @clan.destroy
        respond_to do |format|
          format.html { redirect_to clans_url, notice: 'Clan was successfully destroyed.' }
          format.json { head :no_content }
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
  