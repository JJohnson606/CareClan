class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: %i[ show edit update destroy ]

  # GET /comments or /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @post = Post.find(params[:post_id])
     @parent_comment = Comment.find_by(id: params[:parent_id]) # Optional, find parent comment if present
     @comment = Comment.new(post_id: params[:post_id], parent_id: params[:parent_id])
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments or /comments.json
  def create
    Rails.logger.info "Parameters: #{params.inspect}" # Log incoming parameters
    @post = Post.find(params[:comment][:post_id])
    @comment = @post.comments.build(comment_params.merge(author: current_user))
    
    if @comment.save
      Rails.logger.info "Comment saved successfully: #{@comment.inspect}" # Log successful save
      redirect_to @post, notice: 'Comment was successfully created.'
    else
      Rails.logger.error "Failed to save comment: #{@comment.errors.full_messages}" # Log error messages
      flash.now[:alert] = 'Failed to create comment.'
      render 'posts/show', status: :unprocessable_entity
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

  private
  
  def set_post
    @post = Post.find(params[:comment][:post_id])
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:body, :post_id, :author_id)
    end
end
