require 'rails_helper'

RSpec.describe 'Homes', type: :request do
  describe 'GET /chartview' do
    it 'returns http success' do
      get '/home/chartview'
      expect(response).to have_http_status(:success)
    end
  end
end
