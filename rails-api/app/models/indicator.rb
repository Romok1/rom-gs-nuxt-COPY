# frozen_string_literal: true

class Indicator < ApplicationRecord
  has_closure_tree # allow for multiple levels of indicators and sub-indicators

  has_many :indicator_scores
  belongs_to :indicator_type
  has_many :layerable_spatial_datasets, as: :layerable, dependent: :destroy
  has_many :spatial_datasets, -> { order(name: :asc) }, through: :layerable_spatial_datasets

  validates_presence_of :name
end
