class Shapefile < ApplicationRecord
  enum status: %i[processing upload_failed uploaded geoserver_error success]

  belongs_to :gef_project

  has_many :shapefile_import_errors, dependent: :destroy
  accepts_nested_attributes_for :shapefile_import_errors, reject_if: lambda { |attributes|
                                                                       attributes['message'].blank?
                                                                     }, allow_destroy: true

  has_many_attached :files

  validates_presence_of :status
end
