class MedicalRecordsController < ApplicationController
  before_action :set_medical_record, only: %i[show edit update destroy]

  # GET /medical_records or /medical_records.json
  def index
    @medical_records = MedicalRecord.all.order(record_date: :desc)
    # Filter by record type if param is present
    if params[:record_type].present?
      @medical_records = @medical_records.where(record_type: params[:record_type])
    end
    # Simple search functionality, adjust according to your needs
    if params[:search].present?
      @medical_records = @medical_records.where("notes LIKE ?", "%#{params[:search]}%")
    end

    @medical_records = @medical_records.page(params[:page]) # Paginate the final query
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
      case permitted_params[:record_type]
      when 'diagnosis'
        notes_data = {
          condition: params[:medical_record][:condition],
          symptoms: params[:medical_record][:symptoms],
          recommended_treatment: params[:medical_record][:recommended_treatment]
        }
        permitted_params[:notes] = notes_data.to_json
  
      when 'imaging'
        notes_data = {
          type: params[:medical_record][:type],
          findings: params[:medical_record][:findings],
          interpretation: params[:medical_record][:interpretation]
        }
        permitted_params[:notes] = notes_data.to_json
  
      when 'lab_results'
        # Assuming lab results are complex and need special handling
        # You would need to serialize each lab test and its results
  
      when 'prescription'
        notes_data = {
          medication_name: params[:medical_record][:medication_name],
          dosage: params[:medical_record][:dosage],
          duration: params[:medical_record][:duration],
          purpose: params[:medical_record][:purpose]
        }
        permitted_params[:notes] = notes_data.to_json
  
      when 'progress_notes'
        notes_data = {
          date: params[:medical_record][:date],
          note: params[:medical_record][:note]
        }
        permitted_params[:notes] = notes_data.to_json
  
      when 'surgical_reports'
        notes_data = {
          procedure: params[:medical_record][:procedure],
          date: params[:medical_record][:date],
          findings: params[:medical_record][:findings],
          outcome: params[:medical_record][:outcome]
        }
        permitted_params[:notes] = notes_data.to_json
  
      when 'treatment_plan'
        notes_data = {
          treatment: params[:medical_record][:treatment],
          duration: params[:medical_record][:duration],
          follow_up: params[:medical_record][:follow_up]
        }
        permitted_params[:notes] = notes_data.to_json
  
      when 'vaccination_records'
        notes_data = {
          vaccine: params[:medical_record][:vaccine],
          date: params[:medical_record][:date],
          lot_number: params[:medical_record][:lot_number],
          site: params[:medical_record][:site]
        }
        permitted_params[:notes] = notes_data.to_json
      end
    end
  end
end