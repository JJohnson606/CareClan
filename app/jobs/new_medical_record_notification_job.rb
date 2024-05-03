class NewMedicalRecordNotificationJob < ApplicationJob
  queue_as :default

  def perform(medical_record)
    medical_record.patient.clans.each do |clan|
      clan.users.each do |user|
        UserMailer.new_medical_record_notification(user, medical_record).deliver_later
      end
    end
  end
end
