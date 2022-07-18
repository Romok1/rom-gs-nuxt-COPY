class FocalArea < ApplicationRecord
  has_and_belongs_to_many :gef_projects
  has_many :layerable_spatial_datasets, as: :layerable, dependent: :destroy
  has_many :spatial_datasets, -> { order(name: :asc) }, through: :layerable_spatial_datasets

  validates_presence_of :name
  validates_uniqueness_of :name
end
