require 'rails_helper'
require 'zip'

RSpec.describe Geoserver::ZipFileBuilders::FromZipFile, type: :model do
  let!(:shapefile) { create(:shapefile, status: :processing) }
  let(:gef_id) { shapefile.gef_project.gef_id }
  let(:zip_file_path) { "#{Rails.root}/tmp/#{gef_id}.zip" }
  let(:errors) { [] }

  after :each do
    # Clean up any tmp files created by the test
    File.delete(zip_file_path) if File.exist?(zip_file_path)
  end

  context 'with valid data' do
    before :each do
      shapefile.files.attach(
        io:  File.open(Rails.root.join('spec', 'fixtures', 'geoserver', 'zip_with_forbidden_files.zip')),
        filename: 'gef_project.zip',
        content_type: 'application/zip'
      )
      @zip_file_path = "#{Rails.root}/tmp/#{gef_id}.zip"
    end

    it 'creates a zip file for geoserver with only required file types' do
      zip_file = shapefile.files.first
      Geoserver::ZipFileBuilders::FromZipFile.new(gef_id, zip_file, errors, zip_file_path).call
      expect(errors.empty?).to eq(true)
      expect(File.exist?(zip_file_path)).to eq(true)

      files_in_final_zip = []
      Zip::File.open(zip_file_path) do |files|
        files.each do |file|
          files_in_final_zip << file.name
        end
      end
      file_base_names = files_in_final_zip.map { |file_name| file_name.split('.').first }
      file_extensions = files_in_final_zip.map { |file_name| file_name.split('.').last }
      expect(file_base_names.uniq.length).to eq(1) # All files have the same base name.
      expect(file_extensions).to match_array %w[shp shx dbf prj]
    end
  end

  context 'with invalid data' do
    context 'missing required extensions' do
      before :each do
        shapefile.files.attach(
          io:  File.open(Rails.root.join('spec', 'fixtures', 'geoserver', 'missing_prj.zip')),
          filename: 'missing_prj.zip',
          content_type: 'application/zip'
        )
        @zip_file_path = "#{Rails.root}/tmp/#{gef_id}.zip"
      end

      it 'does not create a zip file in the tmp directory' do
        zip_file = shapefile.files.first
        Geoserver::ZipFileBuilders::FromZipFile.new(gef_id, zip_file, errors, zip_file_path).call
        expect(errors.empty?).to eq(false)
        expect(File.exist?(zip_file_path)).to eq(false)
      end
    end

    context 'inconsistent file base names' do
      before :each do
        shapefile.files.attach(
          io:  File.open(Rails.root.join('spec', 'fixtures', 'geoserver', 'inconsistent_base_names.zip')),
          filename: 'inconsistent_base_names.zip',
          content_type: 'application/zip'
        )
        @zip_file_path = "#{Rails.root}/tmp/#{gef_id}.zip"
      end

      it 'does not create a zip file in the tmp directory' do
        zip_file = shapefile.files.first
        Geoserver::ZipFileBuilders::FromZipFile.new(gef_id, zip_file, errors, zip_file_path).call
        expect(errors.empty?).to eq(false)
        expect(File.exist?(zip_file_path)).to eq(false)
      end
    end
  end
end
