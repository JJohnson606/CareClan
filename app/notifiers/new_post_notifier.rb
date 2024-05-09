class NewPostNotifier < Noticed::Event
  deliver_by :email, mailer: 'UserMailer', method: :new_post_notification
  required_param :user
  required_param :post

  def to_mailer
    {
      user: params[:user],
      post: params[:post]
    }
  end
end
