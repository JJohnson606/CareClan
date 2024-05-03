class NewCommentNotifier < Noticed::Event
  deliver_by :email, mailer: "UserMailer", method: :new_comment_notification
  required_param :post
  required_param :user
  required_param :comment

  def to_mailer
    {
      user: params[:user],
      post: params[:post],
      comment: params[:comment]
    }
  end
end
