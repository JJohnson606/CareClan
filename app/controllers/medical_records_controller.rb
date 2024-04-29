class MedicalRecordsController < ApplicationController
  before_action :set_medical_record, only: %i[show edit update destroy]

  # GET /medical_records or /medical_records.json
  def index
    @q = MedicalRecord.ransack(params[:q])
    case params[:search_type]
    when 'name'
      # Ensure creators and their profile pictures are preloaded
      @q = MedicalRecord.joins(:creator).includes(creator: [:profile_picture_attachment]).ransack(creator_name_cont: params[:search])
    when 'date'
      @q = MedicalRecord.ransack(record_date_eq: params[:search])
    when 'record_type'
      @q = MedicalRecord.ransack(record_type_eq: params[:search])
    else
      @q = MedicalRecord.ransack(params[:q])
    end

    # Preload patients and their profile pictures as well as creators and their profile pictures
    @medical_records = @q.result(distinct: true)
    .includes(patient: [profile_picture_attachment: :blob],
              creator: [profile_picture_attachment: :blob])
    .page(params[:page])

  end

  # GET /medical_records/1 or /medical_records/1.json
  def show
  end

  # GET /medical_records/new
  def new
    @medical_record = MedicalRecord.new
    @patients = User.patients # Method for fetching patient users
    @creators = User.healthcare_professionals # Method for fetching healthcare professional users
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

    respond_to do |format|
      if @medical_record.save
        NewMedicalRecordNotificationJob.perform_later(current_user, @medical_record)
        format.html { redirect_to medical_record_url(@medical_record), notice: "Medical record was successfully created." }
        format.json { render :show, status: :created, location: @medical_record }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @medical_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /medical_records/1 or /medical_records/1.json
  def update
    respond_to do |format|
      if @medical_record.update(medical_record_params)
        format.html { redirect_to medical_record_url(@medical_record), notice: "Medical record was successfully updated." }
        format.json { render :show, status: :ok, location: @medical_record }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @medical_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /medical_records/1 or /medical_records/1.json
  def destroy
    @medical_record.destroy
    respond_to do |format|
      format.html { redirect_to medical_records_url, notice: "Medical record was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def load_partial
    # Ensure this 'form' object is correctly initialized as needed for your partials
    render partial: "medical_records/partials/#{params[:record_type]}", locals: { medical_record: @medical_record }
  end

  def fields_partial
    render partial: "medical_records/partials/#{params[:record_type]}_fields", locals: { form: form_builder }
  end

  def form_builder
    # This method should return a form builder instance that can be used in the partial
    # For example, if using simple_form, you might do something like this:
    SimpleForm::FormBuilder.new('medical_record', @medical_record, self.view_context, {})
    # If using Rails' form builder, you might need to instantiate it differently
  end
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_medical_record
    @medical_record = MedicalRecord.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def medical_record_params
    params.require(:medical_record).permit(:patient_id, :record_type, :record_date, :created_by_id, images: []).tap do |permitted_params|
      permitted_params[:notes] = case permitted_params[:record_type]
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
end
