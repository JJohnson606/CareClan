class NewMedicalRecordNotifier < Noticed::Base
  deliver_by :database  # logs to the database
  deliver_by :email, mailer: 'UserMailer', method: :new_medical_record_notification

  required_param :medical_record

  def to_database
    {
      title: "New Medical Record Added",
      text: "A new medical record for #{params[:medical_record].patient.name} has been added."
    }
  end

  def to_mailer
    UserMailer.new_medical_record_notification(params[:medical_record].patient, params[:medical_record])
  end
end
