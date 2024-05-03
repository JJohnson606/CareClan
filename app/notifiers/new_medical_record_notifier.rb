class NewMedicalRecordNotifier < Noticed::Event
  deliver_by :email, mailer: "UserMailer", method: :new_medical_record_notification

  required_param :user
  required_param :medical_record

  def to_mailer
    UserMailer.new_medical_record_notification(params[:medical_record].patient, params[:medical_record])
  end
end
