require 'rails_helper'

RSpec.describe SpatialDataset, type: :model do
  context 'associations' do
    let!(:spatial_dataset_url) { build(:spatial_dataset_url) }
    let!(:spatial_dataset) { create(:spatial_dataset, spatial_dataset_urls: [spatial_dataset_url]) }
    let!(:layerable_spatial_dataset) { create(:layerable_spatial_dataset, spatial_dataset:) }

    it 'can be linked to layerables' do
      focal_area = spatial_dataset.focal_areas.first
      expect(focal_area.spatial_datasets).to eq [spatial_dataset]
    end
  end

  context 'multiple spatial_dataset_urls' do
    context 'with dates' do
      let!(:spatial_dataset_urls) { build_list(:spatial_dataset_url, 2) }
      let!(:spatial_dataset) { build(:spatial_dataset, spatial_dataset_urls:) }

      it 'saves successfully' do
        expect(spatial_dataset.save).to eq(true)
      end
    end

    context 'without dates' do
      let!(:spatial_dataset_urls) { build_list(:spatial_dataset_url, 2, date: nil) }
      let!(:spatial_dataset) { build(:spatial_dataset, spatial_dataset_urls:) }

      it 'does not save' do
        expect(spatial_dataset.save).to eq(false)
        expect(spatial_dataset.errors.full_messages).to eq [I18n.t('activerecord.errors.models.spatial_datasets.attributes.multiple_layers_require_dates')]
      end
    end
  end
end
