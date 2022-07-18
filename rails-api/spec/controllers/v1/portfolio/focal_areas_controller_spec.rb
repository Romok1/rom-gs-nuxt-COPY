require 'rails_helper'

RSpec.describe V1::Portfolio::FocalAreasController, type: :controller do
  include_context 'user_setup'

  describe '#index' do
    let!(:gef_project_for_task_manager) do
      gef_project = create(:gef_project_with_user_with_role, user: task_manager, role: task_manager.role)
      create(:focal_area, gef_projects: [gef_project])
      gef_project
    end

    let!(:gef_project_without_task_manager) do
      gef_project = create(:gef_project)
      create(:focal_area, gef_projects: [gef_project])
      gef_project
    end

    context 'as portfolio_manager' do
      before do
        sign_in portfolio_manager
      end

      it 'returns a list of focal areas for all projects' do
        get :index, format: :json
        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body.length).to eq(FocalArea.count)
        expect(response_body.pluck('name')).to match_array(FocalArea.pluck(:name))
      end
    end

    context 'as task_manager' do
      before do
        sign_in task_manager
      end

      it 'returns a list of focal areas linked to the task_manager' do
        get :index, format: :json
        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body.length).to eq(1)
        expect(response_body.first['name']).to eq(gef_project_for_task_manager.focal_areas.first.name)
      end
    end
  end
end
