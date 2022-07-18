require 'rails_helper'

RSpec.describe V1::Portfolio::GeoregionsController, type: :controller do
  include_context 'user_setup'

  describe '#index' do
    let!(:gef_project_for_task_manager) do
      gef_project = create(:gef_project_with_user_with_role, user: task_manager, role: task_manager.role)
      create(:country, gef_projects: [gef_project])
      gef_project
    end

    let!(:gef_project_without_task_manager) do
      gef_project = create(:gef_project)
      create(:region, gef_projects: [gef_project])
      gef_project
    end

    context 'as portfolio_manager' do
      before do
        sign_in portfolio_manager
      end

      it 'returns a list of georegions for all projects' do
        get :index, format: :json
        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body.length).to eq(Georegion.count)
        expect(response_body.pluck('name')).to match_array(Georegion.pluck(:name))
      end
    end

    context 'as task_manager' do
      before do
        sign_in task_manager
      end

      it 'returns a list of georegions linked to the task manager' do
        get :index, format: :json
        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body.length).to eq(1)
        expect(response_body.first['name']).to eq(gef_project_for_task_manager.georegions.first.name)
      end
    end
  end
end
