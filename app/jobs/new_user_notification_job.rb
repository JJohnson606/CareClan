# frozen_string_literal: true

# Job to send notifications when a new user is created
class NewUserNotificationJob < ApplicationJob
  queue_as :default

  def perform(user)
    # Send welcome email to the new user
    NewUserWelcomeNotifier.with(user:).deliver_later

    # Notify clan members about the new user, excluding the user themselves
    user.clans.each do |clan|
      clan_members = clan.users.where.not(id: user.id)
      next unless clan_members.any?

      clan_members.each do |_member|
        NewUserClanNotifier.with(user:, clan:).deliver_later
      end
    end
  end
end
