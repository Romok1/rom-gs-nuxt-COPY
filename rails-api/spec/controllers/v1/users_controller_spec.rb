require 'rails_helper'

RSpec.describe V1::UsersController, type: :controller do
  describe 'GET #index' do
    context 'user not authenticated' do
      it 'returns the devise unauthenticated error' do
        get :index, format: :json
        expect(JSON.parse(response.body)['error']).to eq I18n.t('devise.failure.unauthenticated')
      end
    end
  end
end