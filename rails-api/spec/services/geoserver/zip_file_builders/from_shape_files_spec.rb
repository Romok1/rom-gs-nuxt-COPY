require 'rails_helper'
require 'zip'

RSpec.describe Geoserver::ZipFileBuilders::FromShapeFiles, type: :model do
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
      %w[gef_project.shp gef_project.dbf gef_project.prj gef_project.shx gef_project.cpg].each do |filename|
        shapefile.files.attach(
          io:  File.open(Rails.root.join('spec', 'fixtures', 'geoserver', filename)),
          filename:,
          content_type: 'application/x-shapefile' # This differs by file extension but doesn't matter here.
        )
      end
      @zip_file_path = "#{Rails.root}/tmp/#{gef_id}.zip"
    end

    it 'creates a zip file for geoserver with only required file types' do
      Geoserver::ZipFileBuilders::FromShapeFiles.new(gef_id, shapefile, errors, zip_file_path).call
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
        %w[gef_project.shp gef_project.dbf gef_project.prj].each do |filename|
          shapefile.files.attach(
            io:  File.open(Rails.root.join('spec', 'fixtures', 'geoserver', filename)),
            filename:,
            content_type: 'application/x-shapefile' # This differs by file extension but doesn't matter here.
          )
        end
        @zip_file_path = "#{Rails.root}/tmp/#{gef_id}.zip"
      end

      it 'does not create a zip file in the tmp directory' do
        Geoserver::ZipFileBuilders::FromShapeFiles.new(gef_id, shapefile, errors, zip_file_path).call
        expect(errors.empty?).to eq(false)
        expect(File.exist?(zip_file_path)).to eq(false)
      end
    end

    context 'inconsistent file base names' do
      before :each do
        %w[gef_project.shp gef_project.dbf gef_project.prj another_base_name.shx].each do |filename|
          shapefile.files.attach(
            io:  File.open(Rails.root.join('spec', 'fixtures', 'geoserver', filename)),
            filename:,
            content_type: 'application/x-shapefile' # This differs by file extension but doesn't matter here.
          )
        end
        @zip_file_path = "#{Rails.root}/tmp/#{gef_id}.zip"
      end

      it 'does not create a zip file in the tmp directory' do
        Geoserver::ZipFileBuilders::FromShapeFiles.new(gef_id, shapefile, errors, zip_file_path).call
        expect(errors.empty?).to eq(false)
        expect(File.exist?(zip_file_path)).to eq(false)
      end
    end
  end
end
