# frozen_string_literal: true

class LayerableSpatialDataset < ApplicationRecord
  belongs_to :spatial_dataset
  belongs_to :layerable, polymorphic: true
end
