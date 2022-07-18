module Geoserver
  class FileListValidator
    VALID_EXTENSIONS = %w[.shp .shx .dbf .prj].freeze

    def initialize(file_list, errors)
      @file_list = file_list
      @errors = errors
    end

    def list_valid?
      all_extensions_present? && file_names_consistent? && no_forbidden_extensions?
    end

    private

    def all_extensions_present?
      if VALID_EXTENSIONS - file_extensions == []
        true
      else
        @errors << I18n.t('services.geoserver.file_list_validator.required_extensions_missing')
        false
      end
    end

    def file_names_consistent?
      if @file_list.map { |file_name| File.basename(file_name, '.*') }.uniq.length == 1
        true
      else
        @errors << I18n.t('services.geoserver.file_list_validator.file_base_names_not_the_same')
        false
      end
    end

    def no_forbidden_extensions?
      if file_extensions - VALID_EXTENSIONS == []
        true
      else
        @errors << I18n.t('services.geoserver.file_list_validator.forbidden_extensions')
        false
      end
    end

    def file_extensions
      @file_extensions ||= @file_list.map { |file_name| File.extname(file_name) }
    end
  end
end
