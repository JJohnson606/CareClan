class UserMailer < ApplicationMailer
    def new_comment_notification(user, post, message)
      @user = user
      @post = post
      @message = message
      mail(to: @user.email, subject: 'New Comment on Your Post')
    end
  end
  