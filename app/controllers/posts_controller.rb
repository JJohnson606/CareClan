class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update,:destroy, :approve, :disapprove]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
     @post = Post.find(params[:id])
     @approval_rating = @post.approval_rating
     @medical_record = @post.medical_record
     @voters_up = User.includes(:votes).where(votes: { votable: @post, vote_flag: true })
     @voters_down = User.includes(:votes).where(votes: { votable: @post, vote_flag: false })
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = current_user.posts.build(post_params)
    respond_to do |format|
      if @post.save
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


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:author_id, :body, :image, :trusted)
    end
end
