require 'zip'

module Geoserver
  module ZipFileBuilders
    class FromShapeFiles
      def initialize(
        gef_project_gef_id,
        shapefile,
        errors,
        file_path,
        file_list_validator = FileListValidator
      )
        @gef_project_gef_id = gef_project_gef_id
        @shapefile = Shapefile.find(shapefile.id)
        @errors = errors
        @file_path = file_path
        @file_list_validator = file_list_validator
      end

      def call
        create_zip_file_for_geoserver
        delete_file unless @file_list_validator.new(file_list, @errors).list_valid?

        if file_not_created_but_no_error_message?
          @errors << I18n.t('services.geoserver.zip_file_builders.file_not_created')
        end
      end

      private

      def create_zip_file_for_geoserver
        # Use the Shapefile attachments to create a zip file for Geoserver
        # containing only .shp, .shx, .dbf, and .prj files.
        @shapefile.files.each do |shapefile_file|
          shapefile_file.blob.open do |tmp_file|
            Zip::File.open(@file_path, create: true) do |zip_file|
              filename = shapefile_file.blob.filename.to_s
              extension = File.extname(filename)
              if extension.in? %w[.shp .shx .dbf .prj]
                zip_file.add(filename, tmp_file.path)
                file_list << filename
              end
            end
          end
        end
      rescue StandardError => e
        @errors << e.message
      end

      def file_list
        @file_list ||= []
      end

      def file_not_created_but_no_error_message?
        @errors.empty? && !File.exist?(@file_path)
      end

      def delete_file
        File.delete(@file_path) if File.exist?(@file_path)
      end
    end
  end
end
