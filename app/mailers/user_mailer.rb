class UserMailer < ApplicationMailer
  def new_user_welcome(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to CareClan')
  end

  def new_user_clan_notification(user, clan)
    @user = user
    @clan = clan
    mail(to: clan.users.pluck(:email), subject: 'New Member Joined Your Clan')
  end

  def new_comment_notification(user, post, comment)
    @user = user
    @post = post
    @comment = comment
    mail(to: @user.email, subject: 'New Comment on Your Post')
  end

  def new_post_notification(user, post)
    @user = user
    @post = post
    mail(to: @user.email, subject: 'New Post Published')
  end

  def new_medical_record_notification(user, medical_record)
    @user = user
    @medical_record = medical_record
    mail(to: @user.email, subject: 'New Medical Record Added')
  end
end
