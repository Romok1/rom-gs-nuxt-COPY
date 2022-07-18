require 'rails_helper'

RSpec.describe Indicator, type: :model do
  let!(:gef_core_indicator_type) { create(:gef_core_indicator_type) }
  let!(:parent_indicator) { create(:indicator, indicator_type: gef_core_indicator_type) }
  let!(:child_indicators) do
    create_list(:indicator, 3, indicator_type: gef_core_indicator_type, parent_id: parent_indicator.id)
  end

  context 'closure_tree' do
    it 'allows sub-indicators' do
      child_indicator = child_indicators.last
      expect(child_indicator.depth).to eq 1
      expect(child_indicator.child?).to eq true
      expect(child_indicator.leaf?).to eq true
      expect(child_indicator.parent).to match(parent_indicator)
    end

    it 'has parent indicator functionality' do
      expect(parent_indicator.depth).to eq 0
      expect(parent_indicator.child?).to eq false
      expect(parent_indicator.leaf?).to eq false
      expect(parent_indicator.children).to match(child_indicators)
    end
  end

  context 'spatial layers' do
    let!(:spatial_dataset_url) { build(:spatial_dataset_url) }
    let!(:spatial_dataset) { create(:spatial_dataset, spatial_dataset_urls: [spatial_dataset_url]) }
    let!(:layerable_spatial_dataset) do
      create_list(:layerable_spatial_dataset, 3, layerable: parent_indicator, spatial_dataset:)
    end

    it 'links indicators to spatial_datasets' do
      expect(parent_indicator.spatial_datasets.count).to eq(3)
    end
  end
end
