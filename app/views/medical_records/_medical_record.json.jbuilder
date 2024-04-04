json.extract! medical_record, :id, :patient_id, :record_type, :record_date, :notes, :created_by_id, :created_at, :updated_at
json.url medical_record_url(medical_record, format: :json)
