require 'rails_helper'

RSpec.describe V1::SyncController, type: :controller do
  include_context 'user_setup'

  describe 'signed in' do
    before do
      sign_in portfolio_manager
    end

    context 'POST #create' do
      context 'when there is no sync in progress' do
        let(:gef_project_import) { build(:gef_project_import, updated_at: DateTime.now, status: :completed) }

        it 'calls ImportJob' do
          allow(GEFProjectImport).to receive(:last_sync).and_return(gef_project_import)
          expect(ImportJob).to receive(:perform_later).once
          post :create
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when there is a sync already in progress' do
        let(:gef_project_import) { build(:gef_project_import, updated_at: DateTime.now, status: :processing) }

        it 'does not call ImportJob' do
          allow(GEFProjectImport).to receive(:last_sync).and_return(gef_project_import)
          expect(ImportJob).not_to receive(:perform_later)
          post :create
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'not signed in' do
    context 'POST #create' do
      it 'does not call ImportJob' do
        expect(ImportJob).not_to receive(:perform_later)
        post :create
        expect(response).to have_http_status(:found)
      end
    end
  end
end
