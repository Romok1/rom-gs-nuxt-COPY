require 'rails_helper'

RSpec.describe V1::PortfoliosController, type: :controller do
  include_context 'user_setup'

  let!(:gef_project) do
    create(:gef_project_with_user_with_role, user: task_manager, role: task_manager_role)
  end
  let!(:indicator) { create(:indicator) }
  let!(:indicator_score) { create(:indicator_score, value: 1, assessment_type: :baseline, gef_project:, indicator:) }

  describe 'signed in' do
    context 'portfolio_manager' do
      before do
        sign_in portfolio_manager
      end

      context 'GET #index' do
        it 'returns a list of undiscarded GEF Projects' do
          get :index, format: :json
          expect(response).to have_http_status(:ok)
          response_parsed = JSON.parse(response.body)
          expect(response_parsed['gef_ids']).to eq([gef_project.gef_id])
          expect(response_parsed['indicator_types']).to eq(
            [
              {
                'id' => indicator.indicator_type.id,
                'name' => indicator.indicator_type.name
              }
            ]
          )
          expect(response_parsed['indicators']).to eq(
            [
              'id' => indicator.id,
              'name' => indicator.name,
              'indicator_type_id' => indicator.indicator_type_id
            ]
          )
        end
      end
    end

    context 'task_manager' do
      before do
        sign_in task_manager
      end

      context 'GET #index' do
        it 'returns a list of undiscarded GEF Projects' do
          get :index, format: :json
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context 'not signed in' do
      context 'GET #index' do
        it 'returns unauthorized' do
          get :index, format: :json
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end
