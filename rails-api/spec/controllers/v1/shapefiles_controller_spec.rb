require 'rails_helper'

RSpec.describe V1::ShapefilesController, type: :controller do
  include_context 'user_setup'

  let!(:gef_project) { create(:gef_project_with_user_with_role, user: task_manager, role: task_manager_role) }
  let!(:shapefile) { create(:shapefile, gef_project:) }
  let!(:gef_project_without_shapefile) do
    create(:gef_project_with_user_with_role, user: task_manager, role: task_manager_role)
  end

  let(:file_signed_id) do
    file = Rails.root.join('spec', 'fixtures', 'geoserver', 'gef_project.zip')
    ActiveStorage::Blob.create_and_upload!(
      io: File.open(file, 'rb'),
      filename: 'gef_project.zip',
      content_type: 'application/zip'
    ).signed_id
  end

  before :example do
    allow(ShapefileUploadJob).to receive(:perform_later).and_return(true)
  end

  describe 'signed in' do
    context 'task_manager' do
      before do
        sign_in task_manager
      end

      it 'GET returns :ok' do
        get :show, params: { gef_project_id: shapefile.gef_project.gef_id }, format: :json
        expect(response).to have_http_status(:ok)
      end

      it 'DELETE returns :ok' do
        delete :destroy, params: { gef_project_id: shapefile.gef_project.gef_id }, format: :json
        expect(response).to have_http_status(:ok)
        expect(Shapefile.find_by(id: shapefile.id)).to eq nil
      end

      it 'PUT returns :ok' do
        put :update, params: { gef_project_id: shapefile.gef_project.gef_id, shapefile: { files: [file_signed_id] } },
          format: :json
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'signed in' do
    context 'portfolio_manager' do
      before do
        sign_in portfolio_manager
      end

      it 'GET returns :forbidden' do
        get :show, params: { gef_project_id: shapefile.gef_project.gef_id }, format: :json
        expect(response).to have_http_status(:forbidden)
      end

      it 'DELETE returns :forbidden' do
        delete :destroy, params: { gef_project_id: shapefile.gef_project.gef_id }, format: :json
        expect(response).to have_http_status(:forbidden)
      end

      it 'PUT returns :forbidden' do
        put :update, params: { gef_project_id: shapefile.gef_project.gef_id }, format: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
