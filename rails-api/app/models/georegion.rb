class Georegion < ApplicationRecord
  belongs_to :georegion_type
  has_and_belongs_to_many :gef_projects

  validates_presence_of :name
  validate :country_cannot_have_empty_location_codes

  private

  def country_cannot_have_empty_location_codes
    errors.add(:base, :codes) if georegion_type&.name == 'country' && (iso.nil? || m49.nil?)
  end
end
