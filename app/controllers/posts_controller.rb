class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :approve, :disapprove]

  # GET /posts or /posts.json
  def index
    # Starting a Ransack search based on query parameters `q`
  @q = Post.ransack(params[:q])
  @posts = @q.result(distinct: true).includes(:author, :comments) # show the author and avoid N+1 queries

  # Optional: Paginate the results
  @posts = @posts.page(params[:page])
  end

  # GET /posts/1 or /posts/1.json
  def show
    @post = Post.find(params[:id])
    @comments = sort_comments # Only top-level comments
    @approval_rating = @post.approval_rating
    @medical_record = @post.medical_record
    @voters_up = User.includes(:votes).where(votes: { votable: @post, vote_flag: true })
    @voters_down = User.includes(:votes).where(votes: { votable: @post, vote_flag: false })
  end

  # GET /posts/new
  def new
    @post = Post.new
    @medical_record = MedicalRecord.find(params[:medical_record_id]) if params[:medical_record_id].present?
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = current_user.posts.build(post_params)
    respond_to do |format|
      if @post.save
        NewPostNotificationJob.perform_later(@post)
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def approve
    @post.liked_by current_user
    redirect_back(fallback_location: root_path)
  end

  def disapprove
    @post.disliked_by current_user
    redirect_back(fallback_location: root_path)
  end

  def sort_comments
    # Initialize a Ransack search on comments of the post
    @q = @post.comments.ransack(params[:q])
    @comments = @q.result(distinct: true)
  
    # Log the sorted comments
    Rails.logger.debug "Sorted Comments: #{@comments.to_a}"
    @comments
  end
  

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
    redirect_to posts_path, alert: "Post not found." unless @post
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :author_id, :body, :image, :trusted, :medical_record_id)
  end
end
