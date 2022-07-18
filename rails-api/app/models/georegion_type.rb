class GeoregionType < ApplicationRecord
  has_many :georegions

  validates_presence_of :name
  validates_uniqueness_of :name
end
