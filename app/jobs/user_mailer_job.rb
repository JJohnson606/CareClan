class UserMailerJob < ApplicationJob
  queue_as :default

  def perform(user, post, message)
    UserMailer.new_comment_notification(user, post, message).deliver_now
  end
end
