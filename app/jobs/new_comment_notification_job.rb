class NewCommentNotificationJob < ApplicationJob
  queue_as :default

  def perform(comment)
    comment.author.clans.each do |clan|
      clan.users.each do |user|
        UserMailer.new_comment_notification(user, comment).deliver_later
      end
    end
  end
end
