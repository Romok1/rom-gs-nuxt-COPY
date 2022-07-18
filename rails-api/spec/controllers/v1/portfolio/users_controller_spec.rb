require 'rails_helper'

RSpec.describe V1::Portfolio::UsersController, type: :controller do
  include_context 'user_setup'

  describe '#index' do
    let!(:gef_project) do
      create(:gef_project_with_user_with_role, user: task_manager, role: task_manager.role)
    end

    context 'as portfolio_manager' do
      before do
        sign_in portfolio_manager
      end

      it 'returns an array of users' do
        get :index, format: :json
        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body.length).to eq(1)
        expect(response_body.first['name']).to eq(task_manager.name)
        expect(response_body.first['id']).to eq(task_manager.id)
      end
    end

    context 'as task_manager' do
      before do
        sign_in task_manager
      end

      it 'returns an empty array' do
        get :index, format: :json
        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body.length).to eq(0)
      end
    end
  end
end
