# frozen_string_literal: true

class CommentsController < ApplicationController
  include PostFindable
  before_action :find_post, except: %i[show edit update destroy approve disapprove]
  before_action :set_post, except: %i[show edit update destroy approve disapprove]
  before_action :set_comment, only: %i[show edit update destroy approve disapprove]
  before_action :find_parent_comment, only: %i[create new]
  before_action :build_comment, only: %i[create new]
  before_action :authorize_comment, only: %i[index show create update approve disapprove]

  # GET /comments or /comments.json
  def index
    @comments = policy_scope(Comment)
  end

  # GET /comments/1 or /comments/1.json
  def show; end

  # GET /comments/new
  def new
    find_parent_comment
    @comment = @post.comments.build(parent_id: params[:parent_id])
  end

  # GET /comments/1/edit
  def edit; end

  # POST /comments or /comments.json
  def create
    find_parent_comment
    @comment = @post.comments.build(comment_params.merge(author: current_user))

    if @comment.save
      redirect_to @post, notice: 'Comment was successfully created.'
    else
      flash.now[:alert] = 'Failed to create comment. You may not have permission to comment.'
      render 'posts/show', status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        redirect_to post_path(@comment.post), notice: 'Comment was successfully updated.'
        format.json { render :show, status: :ok, location: @comment }
      else
        render :edit
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def approve
    @comment.liked_by current_user
    redirect_to post_path(@comment.post), notice: 'Comment approved!'
  end

  def disapprove
    @comment.disliked_by current_user
    redirect_to post_path(@comment.post), notice: 'Comment disapproved!'
  end

  private

  def set_post
    if params[:post_id]
      @post = Post.find(params[:post_id])
    elsif params[:comment_id]
      # 'comment_id' is the parent comment's ID when replying
      parent_comment = Comment.find(params[:comment_id])
      @post = parent_comment.post
    else
      redirect_to root_url, alert: 'Post not found.'
    end
  end

  def find_parent_comment
    @parent_comment = Comment.find_by(id: params[:parent_id]) if params[:parent_id].present?
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def build_comment
    @comment = @post.comments.build(comment_params.merge(author: current_user))
    @comment.parent = @parent_comment if @parent_comment.present?
  end

  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end

  def authorize_comment
    authorize @comment
  end
end
