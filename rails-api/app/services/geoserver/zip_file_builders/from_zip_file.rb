require 'zip'

module Geoserver
  module ZipFileBuilders
    class FromZipFile
      def initialize(
        gef_project_gef_id,
        zip_file,
        errors,
        file_path,
        file_list_validator = FileListValidator
      )
        @gef_project_gef_id = gef_project_gef_id
        @zip_file = zip_file
        @errors = errors
        @file_path = file_path
        @file_list_validator = file_list_validator
      end

      def call
        create_zip_file_for_geoserver

        @errors << I18n.t('services.geoserver.zip_file_builders.file_not_created') if file_deleted_but_no_error_message?
      end

      private

      def create_zip_file_for_geoserver
        # Remove unwanted files from the zip file and create a new zip file
        # for upload to geoserver
        @zip_file.blob.open do |zip_file|
          Zip::File.open(zip_file, create: true) do |files|
            files.each do |file|
              if File.extname(file.name).in? %w[.shp .shx .dbf .prj]
                file_list << file.name
              else
                remove_list << file.name
              end
            end
            remove_list.each do |file_name|
              files.remove(file_name)
            end
          end
          if @file_list_validator.new(file_list, @errors).list_valid?
            FileUtils.mv(zip_file.path, @file_path)
            ObjectSpace.undefine_finalizer(@file_path)
          else
            delete_file
          end
        end
      end

      def file_list
        @file_list ||= []
      end

      def remove_list
        @remove_list ||= []
      end

      def file_deleted_but_no_error_message?
        @errors.empty? && !File.exist?(@file_path)
      end

      def delete_file
        File.delete(@file_path) if File.exist?(@file_path)
      end
    end
  end
end
