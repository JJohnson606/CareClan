class NewUserClanNotifier < Noticed::Event
  deliver_by :email, mailer: 'UserMailer', method: :new_user_clan_notification

  required_param :user
  required_param :clan

  def to_mailer
    {
      user: params[:user],
      clan: params[:clan]
    }
  end
end
