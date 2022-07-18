require 'rails_helper'

RSpec.describe V1::LastSyncController, type: :controller do
  include_context 'user_setup'

  describe 'signed in' do
    before do
      sign_in portfolio_manager
    end

    context 'GET #show' do
      let(:gef_project_import) { build(:gef_project_import, updated_at: DateTime.now, status: :processing) }

      it 'returns the last sync' do
        allow(GEFProjectImport).to receive(:last).and_return(gef_project_import)
        get :show
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to eq(gef_project_import.as_json(only: %i[updated_at status]))
      end
    end
  end

  describe 'not signed in' do
    context 'GET #show' do
      let(:gef_project_import) { build(:gef_project_import, updated_at: DateTime.now, status: :processing) }

      it 'does not return the last sync' do
        allow(GEFProjectImport).to receive(:last).and_return(gef_project_import)
        get :show
        expect(response).to have_http_status(:found)
      end
    end
  end
end
