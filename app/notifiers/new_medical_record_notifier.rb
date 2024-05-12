class NewMedicalRecordNotifier < Noticed::Event
  deliver_by :email, mailer: 'UserMailer', method: :new_medical_record_notification

  required_param :user
  required_param :medical_record

  def to_mailer
    {
      user: params[:medical_record].patient,
      medical_record: params[:medical_record]
    }
  end
end
