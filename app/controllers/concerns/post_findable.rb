module PostFindable
  extend ActiveSupport::Concern

  private

  def find_post
    if params[:post_id]
      @post = Post.find(params[:post_id])
    elsif params[:comment_id]
      parent_comment = Comment.find(params[:comment_id])
      @post = parent_comment.post
    else
      redirect_to root_url, alert: "Post not found."
    end
  end
end
