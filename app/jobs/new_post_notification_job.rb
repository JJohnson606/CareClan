class NewPostNotificationJob < ApplicationJob
  queue_as :default

  def perform(post)
    post.author.clans.each do |clan|
      clan.users.each do |user|
        UserMailer.new_post_notification(user, post).deliver_later
      end
    end
  end
end
