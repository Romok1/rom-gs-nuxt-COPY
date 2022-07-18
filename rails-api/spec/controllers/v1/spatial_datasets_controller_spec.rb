require 'rails_helper'

RSpec.describe V1::SpatialDatasetsController, type: :controller do
  include_context 'user_setup'

  describe 'signed in' do
    before do
      sign_in task_manager
    end

    context '#index' do
      let!(:spatial_dataset_urls) { build_list(:spatial_dataset_url, 2) }
      let!(:spatial_dataset) do
        create(:spatial_dataset, spatial_dataset_urls:)
      end

      context 'FocalArea' do
        let!(:focal_area) { create(:focal_area, spatial_datasets: [spatial_dataset]) }

        it 'returns a list of layers associated to record' do
          get :index, params: { focal_area_id: focal_area.id }, format: :json
          expect(response).to have_http_status :ok
          response_body = JSON.parse(response.body)
          expect(response_body.length).to eq(1)
          expect(response_body.first['spatial_dataset_urls'].length).to eq(spatial_dataset_urls.length)
        end
      end

      context 'Indicator' do
        let!(:indicator) { create(:indicator, spatial_datasets: [spatial_dataset]) }

        it 'returns a list of layers associated to record' do
          get :index, params: { indicator_id: indicator.id }, format: :json
          expect(response).to have_http_status :ok
          response_body = JSON.parse(response.body)
          expect(response_body.length).to eq(1)
          expect(response_body.first['spatial_dataset_urls'].length).to eq(spatial_dataset_urls.length)
        end
      end
    end
  end
end
