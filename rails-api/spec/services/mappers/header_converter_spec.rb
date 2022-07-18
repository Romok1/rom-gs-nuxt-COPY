require 'rails_helper'

RSpec.describe Mappers::HeaderConverter, type: :model do
  describe '#build_dictionary' do
    it 'matches the spreadsheet headers to the desired headers' do
      spreadsheet_headers = ['Header1', 'header    2', '    HEADER 3', 'header 4']
      desired_headers = { header_1: 'header 1', header_2: 'header 2', header_3: 'header 3' }
      dictionary = Mappers::HeaderConverter.build_dictionary(spreadsheet_headers, desired_headers)

      expect(dictionary.keys).to match_array(desired_headers.keys - [:header_4])
      expect(dictionary.values).to match_array(spreadsheet_headers - ['header 4'])
    end
  end
end
