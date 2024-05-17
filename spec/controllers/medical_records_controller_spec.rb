require 'rails_helper'

RSpec.describe MedicalRecordsController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      medical_record = MedicalRecord.create!(name: 'John Doe', age: 30)
      get :show, params: { id: medical_record.id }
      expect(response).to be_successful
    end
  end
end
