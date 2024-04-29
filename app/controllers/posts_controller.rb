# frozen_string_literal: true

class PostsController < ApplicationController
  include PostLoadable
  respond_to :html, :json
  before_action :load_post, only: %i[show edit update destroy approve disapprove]

  # GET /posts or /posts.json
  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:author, image_attachment: :blob)
    @posts = @q.result(distinct: true).page(params[:page])
  end

  # GET /posts/1 or /posts/1.json
  def show
    @comments = CommentSorter.new(@post, params[:q]).sort
    @approval_rating = @post.approval_rating
    @medical_record = @post.medical_record
    @voters_up = @post.voters_up
    @voters_down = @post.voters_down
  end

  # GET /posts/new
  def new
    @post = Post.new
    set_medical_record
  end

  # GET /posts/1/edit
  def edit; end

  # POST /posts or /posts.json
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      NewPostNotificationJob.perform_later(@post)
      respond_with @post, location: post_url(@post), notice: 'Post was successfully created.'
    else
      respond_with @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    if @post.update(post_params)
      respond_with @post, location: post_url(@post), notice: 'Post was successfully updated.'
    else
      respond_with @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # Approve (like) the current post
  def approve
    @post.liked_by current_user
    flash[:notice] = 'Post approved successfully.'
    redirect_back(fallback_location: root_path)
  end

  # Disapprove (dislike) the current post
  def disapprove
    @post.disliked_by current_user
    flash[:notice] = 'Post disapproved successfully.'
    redirect_back(fallback_location: root_path)
  end

  private

  def post_params
    params.require(:post).permit(:title, :author_id, :body, :image, :trusted, :medical_record_id)
  end

  def load_post
    @post = Post.find(params[:id])
  end
end
