class DashboardController < ApplicationController
  def index
    @posts = Post.includes(:comments, :medical_record).where(author: current_user)
  end
end
