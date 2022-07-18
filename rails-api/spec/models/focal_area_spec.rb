require 'rails_helper'

RSpec.describe FocalArea, type: :model do
  context 'spatial layers' do
    let!(:focal_area) { create(:focal_area) }
    let!(:spatial_dataset_url) { build(:spatial_dataset_url) }
    let!(:spatial_dataset) { create(:spatial_dataset, spatial_dataset_urls: [spatial_dataset_url]) }
    let!(:layerable_spatial_datasets) do
      create_list(:layerable_spatial_dataset, 3, layerable: focal_area, spatial_dataset:)
    end

    it 'links indicators to spatial_datasets' do
      expect(focal_area.spatial_datasets.count).to eq(3)
    end
  end
end
