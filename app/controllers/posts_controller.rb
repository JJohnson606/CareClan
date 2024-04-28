class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :approve, :disapprove]
  respond_to :html, :json

  # GET /posts or /posts.json
  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:author, image_attachment: :blob)
    @posts = @posts.page(params[:page])
  end


  # GET /posts/1 or /posts/1.json
  def show
      @post = Post.includes(
        :image_attachment,
        author: { profile_picture_attachment: :blob },
        comments: [
          { author: { profile_picture_attachment: :blob } },
          { replies: [:author, { author: { profile_picture_attachment: :blob } }] }
        ]
      ).find(params[:id])

    @comments = CommentSorter.new(@post, params[:q]).sort
    @approval_rating = @post.approval_rating
    @medical_record = @post.medical_record
    @voters_up = User.joins(:votes).where(votes: { votable: @post, vote_flag: true }).includes(:profile_picture_attachment)
    @voters_down = User.joins(:votes).where(votes: { votable: @post, vote_flag: false }).includes(:profile_picture_attachment)
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
  if @post.save
    NewPostNotificationJob.perform_later(@post)
    respond_with @post, location: post_url(@post), notice: "Post was successfully created."
  else
    respond_with @post.errors, status: :unprocessable_entity
  end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    if @post.update(post_params)
      respond_with @post, location: post_url(@post), notice: "Post was successfully updated."
    else
      respond_with @post.errors, status: :unprocessable_entity
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
