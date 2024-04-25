class NewCommentNotifier < Noticed::Base
  deliver_by :email, mailer: "UserMailer", method: :new_comment_notification, if: -> { user.allow_email_notifications? }
  param :post, :user, :message

  def to_mailer
    {
      user: params[:user],
      post: params[:post],
      message: params[:message]
    }
  end
end
