require 'rails_helper'

RSpec.describe V1::ChartsController, type: :controller do
  include_context 'user_setup'

  let!(:gef_project) do
    create(:gef_project_with_user_with_role, user: task_manager, role: task_manager_role)
  end
  let!(:indicator) { create(:indicator) }
  let!(:indicator_score) { create(:indicator_score, value: 1, assessment_type: :baseline, gef_project:, indicator:) }

  before do
    sign_in task_manager
  end

  context 'GET #show' do
    it 'returns ok' do
      allow_any_instance_of(Geoserver::Geojson).to receive(:call)

      get :show, params: { id: indicator.id }, format: :json
      expect(response).to have_http_status(:ok)
    end
  end
end
