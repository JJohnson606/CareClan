class UserMailer < ApplicationMailer
    def new_comment_notification(user, post, message)
      @user = user
      @post = post
      @message = message
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
  