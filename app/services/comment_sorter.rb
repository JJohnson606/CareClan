class CommentSorter
  def initialize(post, params)
    @post = post
    @params = params
  end

  def sort
    # Initialize a Ransack search on comments of the post
    @q = @post.comments.includes(author: { profile_picture_attachment: :blob }).ransack(@params)
    @comments = @q.result(distinct: true)

    # Log the sorted comments
    Rails.logger.debug "Sorted Comments: #{@comments.to_a}"

    @comments
  end
end
