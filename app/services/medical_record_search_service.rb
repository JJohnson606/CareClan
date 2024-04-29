class MedicalRecordSearchService
  def initialize(params)
    @params = params
  end

  def call
    case @params[:search_type]
    when 'name'
      search_by_creator_name
    when 'date'
      search_by_record_date
    when 'record_type'
      search_by_record_type
    else
      search_all
    end
  end

  private

  def search_by_creator_name
    MedicalRecord.joins(:creator)
                 .includes(creator: [:profile_picture_attachment])
                 .ransack(creator_name_cont: @params[:search])
  end

  def search_by_record_date
    MedicalRecord.ransack(record_date_eq: @params[:search])
  end

  def search_by_record_type
    MedicalRecord.ransack(record_type_eq: @params[:search])
  end

  def search_all
    MedicalRecord.ransack(@params[:q])
  end
end
