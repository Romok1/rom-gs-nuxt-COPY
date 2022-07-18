require 'rails_helper'

RSpec.describe V1::GeospatialLayers::GEFProjectsController, type: :controller do
  include_context 'user_setup'

  before :example do
    sign_in task_manager
  end

  describe '#index' do
    let!(:gef_projects) do
      create_list(:gef_project_with_user_with_role, 5, user: task_manager, role: task_manager_role)
    end
    let!(:gef_project_with_a_different_user) { create(:gef_project) }

    it 'returns an array of options' do
      get :index
      expect(response).to have_http_status :ok
      expect(JSON.parse(response.body).length).to eq gef_projects.count
    end
  end

  describe '#show' do
    let!(:gef_project) { create(:gef_project_with_user_with_role, user: task_manager, role: task_manager_role) }
    let!(:gef_core_indicator) { create(:indicator) }
    let(:tag) { gef_core_indicator.tag }

    it 'returns an indicator summary object' do
      expect_any_instance_of(Indicators::Summary).to receive(:call).once
      get :show, params: { id: gef_project.gef_id, tag: }
      expect(response).to have_http_status :ok
    end
  end
end
