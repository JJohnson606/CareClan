class CommentsController < ApplicationController
  before_action :set_post, except: [:show, :edit, :update, :destroy, :approve, :disapprove]
  before_action :set_comment, only: [:show, :edit, :update, :destroy, :approve, :disapprove]
  before_action :set_parent_comment, only: [:create, :new]

  # GET /comments or /comments.json
  def index
    @comments = Comment.includes(:author, replies: :author).all
  end

  # GET /comments/1 or /comments/1.json
  def show
    @comment = Comment.includes(replies: :author).find(params[:id])
  end

  # GET /comments/new
  def new
    @comment = @post.comments.create(parent_id: params[:parent_id])
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments or /comments.json
  def create
    @comment = @post.comments.create(comment_params.merge(author: current_user))
    if @comment.save
      Rails.logger.debug "Processing as: #{request.format.to_sym}"
      respond_to do |format|
        format.html { redirect_to @post, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
        format.turbo_stream
        format.js
      end
    else
      respond_to do |format|
        format.html { render 'posts/show', status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("comment_form", partial: "comments/form", locals: { comment: @comment }) }
        format.js
      end
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to comment_url(@comment), notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to comments_url, notice: "Comment was successfully destroyed." }
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
    #'comment_id' is the parent comment's ID when replying
    parent_comment = Comment.find(params[:comment_id])
    @post = parent_comment.post
  else
    redirect_to root_url, alert: "Post not found."
  end
end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_parent_comment
    @parent_comment = Comment.find_by(id: params[:parent_id]) if params[:parent_id].present?  #`comment_id` is how you pass the parent comment's ID
  end

  def comment_params
    params.require(:comment).permit(:body, :parent_id, :author_id)
  end
end

