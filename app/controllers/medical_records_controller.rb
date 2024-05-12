# frozen_string_literal: true

class MedicalRecordsController < ApplicationController
  before_action :set_medical_record, only: %i[show edit update destroy]

  # GET /medical_records or /medical_records.json
  def index
    @q = MedicalRecordSearchService.new(params).call
    @medical_records = @q.result(distinct: true)
                         .includes(patient: [profile_picture_attachment: :blob],
                                   creator: [profile_picture_attachment: :blob])
                         .page(params[:page])
  end

  # GET /medical_records/1 or /medical_records/1.json
  def show; end

  # GET /medical_records/new
  def new
    @medical_record = MedicalRecord.new
    @patients = User.patients
    @creators = User.healthcare_professionals
  end

  # GET /medical_records/1/edit
  def edit
    @medical_record = MedicalRecord.find(params[:id])
    @patients = User.patients
    @creators = User.healthcare_professionals
  end

  # POST /medical_records or /medical_records.json
  def create
    @medical_record = MedicalRecord.new(medical_record_params)

    if @medical_record.save
      redirect_to medical_record_url(@medical_record), notice: 'Medical record was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /medical_records/1 or /medical_records/1.json
  def update
    if @medical_record.update(medical_record_params)
      redirect_to medical_record_url(@medical_record), notice: 'Medical record was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /medical_records/1 or /medical_records/1.json
  def destroy
    @medical_record.destroy
    redirect_to medical_records_url, notice: 'Medical record was successfully destroyed.'
  end

  def load_partial
    render partial: "medical_records/partials/#{params[:record_type]}", locals: { medical_record: @medical_record }
  end

  def fields_partial
    render partial: "medical_records/partials/#{params[:record_type]}_fields", locals: { form: form_builder }
  end

  def form_builder
    SimpleForm::FormBuilder.new('medical_record', @medical_record, view_context, {})
  end

  private

  def set_medical_record
    @medical_record = MedicalRecord.find(params[:id])
  end

  def medical_record_params
    params.require(:medical_record).permit(:patient_id, :record_type, :record_date, :created_by_id, images: [])
          .tap do |permitted_params|
      permitted_params[:notes] = notes_params(permitted_params[:record_type])
    end
  end

  def notes_params(record_type)
    case record_type
    when 'diagnosis'
      RecordTypes::DiagnosisNotes.permitted_params(params)
    when 'treatment_plan'
      RecordTypes::TreatmentPlanNotes.permitted_params(params)
    when 'prescription'
      RecordTypes::PrescriptionNotes.permitted_params(params)
    when 'imaging'
      RecordTypes::ImagingNotes.permitted_params(params)
    when 'progress_notes'
      RecordTypes::ProgressNotesNotes.permitted_params(params)
    when 'surgical_reports'
      RecordTypes::SurgicalReportsNotes.permitted_params(params)
    when 'vaccination_records'
      RecordTypes::VaccinationRecordsNotes.permitted_params(params)
    when 'lab_results'
      RecordTypes::LabResultsNotes.permitted_params(params)
    end
  end
end
