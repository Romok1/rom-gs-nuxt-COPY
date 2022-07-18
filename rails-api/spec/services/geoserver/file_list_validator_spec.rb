require 'rails_helper'

RSpec.describe Geoserver::FileListValidator, type: :model do
  subject { described_class.new(file_list, errors) }
  let(:errors) { [] }

  context 'valid data' do
    let(:file_list) { %w[gef_project.shp gef_project.dbf gef_project.prj gef_project.shx] }

    it 'returns true with no errors' do
      expect(subject.list_valid?).to eq true
      expect(errors.empty?).to eq true
    end
  end

  context 'with invalid data' do
    context 'inconsistent file base names' do
      let(:file_list) { %w[gef_project.shp gef_project.dbf gef_project.prj different.shx] }
      it 'returns false with an error' do
        expect(subject.list_valid?).to eq false
        expect(errors).to match_array(I18n.t('services.geoserver.file_list_validator.file_base_names_not_the_same'))
      end
    end

    context 'missing file extensions' do
      let(:file_list) { %w[gef_project.shp gef_project.dbf gef_project.prj] }
      it 'returns false with an error' do
        expect(subject.list_valid?).to eq false
        expect(errors).to match_array(I18n.t('services.geoserver.file_list_validator.required_extensions_missing'))
      end
    end

    context 'file list includes forbidden file types' do
      let(:file_list) do
        %w[gef_project.shp gef_project.dbf gef_project.prj gef_project.shx gef_project.exe]
      end
      it 'returns false with an error' do
        expect(subject.list_valid?).to eq false
        expect(errors).to match_array(I18n.t('services.geoserver.file_list_validator.forbidden_extensions'))
      end
    end
  end
end
