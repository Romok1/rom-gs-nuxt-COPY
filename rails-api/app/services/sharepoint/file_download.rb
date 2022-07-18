module Sharepoint
  class FileDownload
    def initialize(import, errors)
      @import = import
      @errors = errors
    end

    def call
      delete_previous_download
      site = get_authenticated_sharepoint_site
      folder = site.folder(Rails.application.credentials.sharepoint.folder)

      file_to_download = find_file_in_folder(folder, @import.spreadsheet_filename) # find the correct file in the folder
      file_to_download.download_to_file(download_location) # actually download the Sharepoint file to the download location

      download_location
    rescue StandardError
      # Clean up files if something went wrong
      @errors << { row_number: 1, message: 'Could not download file from Sharepoint', gef_project_id: nil }
      File.delete(download_location) if File.exist?(download_location)
    end

    private

    def delete_previous_download
      ::File.delete(download_location) if ::File.exist?(download_location)
    end

    def find_file_in_folder(folder_to_search_in, name_of_sought_file)
      is_sought_file = ->(file) { file.name == name_of_sought_file }

      folder_to_search_in.files.find(&is_sought_file)
    end

    def get_authenticated_sharepoint_site
      site = Sharepoint::Site.new(Rails.application.credentials.sharepoint.server_url,
        Rails.application.credentials.sharepoint.site_name)

      site.session.authenticate(Rails.application.credentials.sharepoint.username,
        Rails.application.credentials.sharepoint.password)

      site
    end

    def download_location
      @download_location ||= "#{Rails.application.credentials.sharepoint.download_directory}#{@import.spreadsheet_filename}"
    end
  end
end
