# frozen_string_literal: true

module Mappers
  class HeaderConverter
    # Generates a hash which can be passed to the CSV.foreach method
    # e.g. { ' sPreadhseet    header   ' => 'Spreadsheet header' }
    # It is faster to do this once here than for each spreadsheet row

    def self.build_dictionary(spreadsheet_headers, desired_headers)
      lookup_list = {}
      desired_headers.each do |key, value|
        actual_header = spreadsheet_headers.find do |spreadsheet_header|
          spreadsheet_header.gsub(/\s+/, '').downcase == value.gsub(/\s+/, '').downcase
        end
        lookup_list[key] = actual_header unless actual_header.nil?
      end
      lookup_list
    end
  end
end
