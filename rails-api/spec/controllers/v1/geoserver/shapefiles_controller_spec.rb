require 'rails_helper'

RSpec.describe V1::Geoserver::ShapefilesController, type: :controller do
  describe '#update' do
    let!(:shapefile) { create(:shapefile, status: 'processing') }
    context 'without geoserver errors' do
      params = {
        status: 'success'
      }
      it 'returns :ok' do
        put :update, params: { id: shapefile.gef_project.gef_id, shapefile: params }, format: :json
        expect(response).to have_http_status(:ok)
        expect(shapefile.reload.status).to eq 'success'
      end
    end

    context 'with geoserver errors' do
      params = {
        status: 'geoserver_error',
        shapefile_import_errors_attributes: [
          { message: 'error message 1' },
          { message: 'error message 2' }
        ]
      }
      it 'returns :ok' do
        put :update, params: { id: shapefile.gef_project.gef_id, shapefile: params }, format: :json
        expect(response).to have_http_status(:ok)
        expect(shapefile.reload.status).to eq 'geoserver_error'
        expect(shapefile.reload.shapefile_import_errors.count).to eq(2)
      end
    end

    context 'with invalid params' do
      params = {
        status: 'invalid_status'
      }

      it 'returns :unprocessable_entity' do
        put :update, params: { id: shapefile.gef_project.gef_id, shapefile: params }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
