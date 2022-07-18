require 'rails_helper'

RSpec.describe V1::ImportErrorsController, type: :controller do
  include_context 'user_setup'

  describe '#index' do
    before do
      sign_in portfolio_manager
    end

    let!(:gef_project) { create(:gef_project) }

    it 'calls Mappers::ImportErrors and returns the result' do
      expect_any_instance_of(Mappers::ImportErrors).to receive(:call)
      get :index, params: { gef_project_id: gef_project.gef_id }, format: :json
      expect(response).to have_http_status(:ok)
    end
  end
end
