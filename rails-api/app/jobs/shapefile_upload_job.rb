class ShapefileUploadJob < ApplicationJob
  queue_as :shapefile_uploads

  def perform(shapefile_id)
    ShapefileUploader.new(shapefile_id).call
  end
end
