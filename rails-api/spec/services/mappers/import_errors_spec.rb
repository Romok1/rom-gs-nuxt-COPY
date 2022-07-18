require 'rails_helper'

RSpec.describe Mappers::ImportErrors, type: :model do
  subject { Mappers::ImportErrors.new(gef_project) }

  describe '#call' do
    let!(:gef_project) { create(:gef_project) }

    context 'with gef_project_import_errors' do
      let!(:gef_project_import) { create(:gef_project_import) }
      let!(:errors) { create_list(:gef_project_import_error, 5, gef_project:, gef_project_import:) }
      let(:data_source) { "#{GEFProjectImport::SPREADSHEET_FILENAME} - #{GEFProjectImport::SPREADSHEET_TAB_NAME}" }

      it 'returns the errors in a hash' do
        errors_hash = subject.call

        expect(errors_hash.length).to eq 1
        expect(errors_hash.first[:data_source]).to eq data_source
        expect(errors_hash.first[:errors].count).to eq errors.count
      end
    end

    context 'with indicator_import_errors' do
      let!(:indicator_import) { create(:indicator_import) }
      let!(:errors) { create_list(:indicator_import_error, 5, gef_project:, indicator_import:) }
      let(:data_source) { "#{IndicatorImport::SPREADSHEET_FILENAME} - #{IndicatorImport::SPREADSHEET_TAB_NAME}" }

      it 'returns the errors in a hash' do
        errors_hash = subject.call

        expect(errors_hash.length).to eq 1
        expect(errors_hash.first[:data_source]).to eq data_source
        expect(errors_hash.first[:errors].count).to eq errors.count
      end
    end

    context 'with shapefile upload errors' do
      let!(:shapefile) { create(:shapefile, gef_project:) }
      let!(:errors) { create_list(:shapefile_import_error, 5, shapefile:) }
      let(:data_source) { 'Shapefile Upload' }

      it 'returns the errors in a hash' do
        errors_hash = subject.call

        expect(errors_hash.length).to eq 1
        expect(errors_hash.first[:data_source]).to eq data_source
        expect(errors_hash.first[:errors].count).to eq errors.count
      end
    end

    context 'with no errors' do
      it 'returns an empty array' do
        errors_hash = subject.call

        expect(errors_hash.length).to eq 0
      end
    end
  end
end
