class NewUserWelcomeNotifier < Noticed::Event
  deliver_by :email, mailer: 'UserMailer', method: :new_user_welcome

  required_param :user

  def to_mailer
    {
      user: params[:user]
    }
  end
end
