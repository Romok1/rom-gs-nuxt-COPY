class ShapefileUploader
  def initialize(shapefile_id)
    @shapefile = Shapefile.find(shapefile_id)
    @gef_project_gef_id = @shapefile.gef_project.gef_id
    @zip_file_path = "tmp/#{@gef_project_gef_id}.zip"
  end

  def call
    clear_shapefile_errors
    build_zip_file
    upload_shapefile if errors.empty? && File.exist?(@zip_file_path)
    delete_temporary_files
    update_shapefile_status_and_errors
  rescue StandardError
    delete_temporary_files
    errors << I18n.t('services.shapefile_uploader.unknown_error') if errors.empty?
    update_shapefile_status_to_upload_failed
  end

  private

  def clear_shapefile_errors
    @shapefile.shapefile_import_errors.destroy_all
  end

  def update_shapefile_status_and_errors
    if errors.any?
      update_shapefile_status_to_upload_failed
    else
      update_shapefile_status_to_uploaded
    end
  end

  def delete_temporary_files
    File.delete(@zip_file_path) if File.exist?(@zip_file_path)
  end

  def build_zip_file
    if file_is_a_single_zip_file?
      Geoserver::ZipFileBuilders::FromZipFile.new(
        @gef_project_gef_id,
        @shapefile.files.first,
        errors,
        @zip_file_path
      ).call
    elsif @shapefile.files.count >= 4
      Geoserver::ZipFileBuilders::FromShapeFiles.new(@gef_project_gef_id, @shapefile, errors, @zip_file_path).call
    else
      errors << I18n.t('services.shapefile_uploader.invalid_file_types')
      nil
    end
  end

  def upload_shapefile
    Geoserver::ScpFileTransfer.new(@gef_project_gef_id, @zip_file_path, errors).call
  end

  def update_shapefile_status_to_upload_failed
    @shapefile.update(status: :upload_failed)
    error_params = errors.map { |error| { message: error } }
    @shapefile.shapefile_import_errors.create(error_params)
  end

  def update_shapefile_status_to_uploaded
    @shapefile.update(status: :uploaded)
  end

  def errors
    @errors ||= []
  end

  def file_is_a_single_zip_file?
    @shapefile.files.length == 1 && @shapefile.files.first.content_type == 'application/zip'
  end
end
