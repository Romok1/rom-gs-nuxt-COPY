# frozen_string_literal: true

class SpatialDatasetUrl < ApplicationRecord
  belongs_to :spatial_dataset

  validates_presence_of :url
  validates_uniqueness_of :date, scope: :spatial_dataset_id
end
