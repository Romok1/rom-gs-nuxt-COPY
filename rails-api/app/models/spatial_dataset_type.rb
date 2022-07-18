# frozen_string_literal: true

class SpatialDatasetType < ApplicationRecord
  has_many :spatial_datasets, dependent: :destroy

  validates_presence_of :name
  validates_uniqueness_of :name
end
