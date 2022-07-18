module Geoserver
  class ScpFileTransfer
    def initialize(gef_project_gef_id, zip_file_path, errors)
      @gef_project_gef_id = gef_project_gef_id
      @zip_file_path = zip_file_path
      @errors = errors
    end

    def call
      # Transfers a file to Geoserver server via SCP. These should always
      # be .zip archives containing .shp, .shx, .dbf, and .prj files.
      upload_file_to_geoserver
      run_python_import_script_on_geoserver
    rescue StandardError => e
      @errors << e.message
      false
    end

    def upload_file_to_geoserver
      Net::SCP.upload!(
        Rails.application.credentials.dig(:geoserver, :remote_host),
        Rails.application.credentials.dig(:geoserver, :username),
        @zip_file_path,
        Rails.application.credentials.dig(:geoserver, :remote_path),
        ssh: {
          password: ''
        }
      )
    end

    def run_python_import_script_on_geoserver
      Net::SSH.start(
        Rails.application.credentials.dig(:geoserver, :remote_host),
        Rails.application.credentials.dig(:geoserver, :username),
        password: ''
      ) do |ssh|
        filename = @zip_file_path.split('/').last
        ssh_command = "python3 grip-import/script/grip_importer.py #{filename}"
        ssh.exec!(ssh_command)
      end
    end
  end
end
