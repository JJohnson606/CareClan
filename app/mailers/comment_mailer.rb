class CommentMailer < ApplicationMailer
    def new_comment(post, user)
      @post = post
      @user = user
      mail(to: @user.email, subject: 'New Comment on Your Post')
    end
  end