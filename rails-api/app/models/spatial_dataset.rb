# frozen_string_literal: true

class SpatialDataset < ApplicationRecord
  has_many :spatial_dataset_urls, -> { order(date: :asc) }, dependent: :destroy
  has_many :layerable_spatial_datasets, dependent: :destroy
  has_many :focal_areas, through: :layerable_spatial_datasets, source: :layerable, source_type: 'FocalArea'
  has_many :indicators, through: :layerable_spatial_datasets, source: :layerable, source_type: 'Indicator'
  belongs_to :spatial_dataset_type, polymorphic: true, dependent: :destroy

  validates_presence_of :name, :description, :spatial_dataset_urls

  validate :spatial_dataset_urls_have_dates_if_multiple?

  private

  def spatial_dataset_urls_have_dates_if_multiple?
    return true if spatial_dataset_urls.length < 2

    return true unless spatial_dataset_urls.map(&:date).any?(nil)

    errors.add(:base,
      I18n.t('activerecord.errors.models.spatial_datasets.attributes.multiple_layers_require_dates'))
  end
end
