require 'rails_helper'

RSpec.describe V1::GeospatialLayers::IndicatorsController, type: :controller do
  include_context 'user_setup'

  before :example do
    sign_in task_manager
  end

  describe '#index' do
    let!(:gef_project) { create(:gef_project_with_user_with_role, user: task_manager, role: task_manager_role) }

    it 'returns an array of options' do
      expect_any_instance_of(Mappers::IndicatorTabs).to receive(:call).once
      get :index, params: { gef_project_id: gef_project.gef_id }, format: :json
      expect(response).to have_http_status :ok
    end
  end
end
