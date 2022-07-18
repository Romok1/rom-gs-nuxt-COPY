require 'rails_helper'

RSpec.describe V1::Portfolio::DateRangesController, type: :controller do
  include_context 'user_setup'

  let!(:gef_project) do
    create(:gef_project_with_user_with_role, user: task_manager, role: task_manager_role)
  end
  let!(:indicator) { create(:indicator) }
  let!(:indicator_score) { create(:indicator_score, value: 1, assessment_type: :baseline, gef_project:, indicator:) }

  describe '#index' do
    before do
      sign_in portfolio_manager
    end

    it 'returns ok' do
      get :index, params: { indicator_id: indicator.id }, format: :json
      expect(response).to have_http_status(:ok)
    end
  end
end
