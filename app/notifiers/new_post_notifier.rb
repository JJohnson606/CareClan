class NewPostNotifier < Noticed::Base
  deliver_by :email, mailer: "UserMailer", method: :new_post_notification
  param :user, :post

  def to_mailer
    {
      user: params[:user],
      post: params[:post]
    }
  end
end