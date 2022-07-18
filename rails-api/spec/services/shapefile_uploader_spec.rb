require 'rails_helper'

RSpec.describe ShapefileUploader, type: :model do
  subject { ShapefileUploader.new(shapefile.id) }

  let!(:shapefile) { create(:shapefile, status: :processing) }

  context 'with valid data' do
    context 'with .zip file' do
      before :each do
        shapefile.files.attach(
          io:  File.open(Rails.root.join('spec', 'fixtures', 'geoserver', 'gef_project.zip')),
          filename: 'gef_project.zip',
          content_type: 'application/zip'
        )
        @zip_file_path = "#{Rails.root}/tmp/#{shapefile.gef_project.gef_id}.zip"
        File.write(@zip_file_path, 'zip file contents')
      end

      it 'builds and uploads a .zip file, uploads it, and updates the Shapefile' do
        expect_any_instance_of(Geoserver::ZipFileBuilders::FromZipFile).to receive(:call).once
        expect_any_instance_of(Geoserver::ZipFileBuilders::FromShapeFiles).not_to receive(:call)
        expect_any_instance_of(Geoserver::ScpFileTransfer).to receive(:call).once

        subject.call

        expect(shapefile.reload.status).to eq('uploaded')
        expect(shapefile.shapefile_import_errors.count).to eq(0)
        expect(File.exist?(@zip_file_path)).to eq(false) # File created in the setup should have been deleted.
      end
    end

    context 'with shapefile files - .shp, .shx, .dbf, .prj' do
      before :each do
        %w[.shp .shx .dbf .prj].each do |extension|
          shapefile.files.attach(
            io:  File.open(Rails.root.join('spec', 'fixtures', 'geoserver', "gef_project#{extension}")),
            filename: "gef_project#{extension}",
            content_type: 'application/x-shapefile' # This differs by file extension but doesn't matter here.
          )
        end
        @zip_file_path = "#{Rails.root}/tmp/#{shapefile.gef_project.gef_id}.zip"
        File.write(@zip_file_path, 'zip file contents')
      end

      it 'builds and uploads a .zip file, uploads it, and updates the Shapefile' do
        expect_any_instance_of(Geoserver::ZipFileBuilders::FromShapeFiles).to receive(:call).once
        expect_any_instance_of(Geoserver::ZipFileBuilders::FromZipFile).not_to receive(:call)
        expect_any_instance_of(Geoserver::ScpFileTransfer).to receive(:call).once

        subject.call

        expect(shapefile.reload.status).to eq('uploaded')
        expect(shapefile.shapefile_import_errors.count).to eq(0)
        expect(File.exist?(@zip_file_path)).to eq(false) # File created in the setup should have been deleted.
      end
    end
  end

  context 'with invalid data' do
    context 'invalid file types' do
      before :each do
        shapefile.files.attach(
          io:  File.open(Rails.root.join('spec', 'fixtures', 'geoserver', 'dodgy.exe')),
          filename: 'gef_project.exe',
          content_type: 'application/exe'
        )

        @zip_file_path = "#{Rails.root}/tmp/#{shapefile.gef_project.gef_id}.zip"
      end

      it 'does not build or upload a file' do
        expect_any_instance_of(Geoserver::ZipFileBuilders::FromShapeFiles).not_to receive(:call)
        expect_any_instance_of(Geoserver::ZipFileBuilders::FromZipFile).not_to receive(:call)
        expect_any_instance_of(Geoserver::ScpFileTransfer).not_to receive(:call)

        subject.call

        expect(shapefile.reload.status).to eq('upload_failed')
        expect(shapefile.shapefile_import_errors.count).to eq(1)
        expect(shapefile.shapefile_import_errors.pluck(:message)).to eq [I18n.t('services.shapefile_uploader.invalid_file_types')]
        expect(File.exist?(@zip_file_path)).to eq(false) # File created in the setup should have been deleted.
      end
    end

    context 'zip file builder fails' do
      context 'with .zip file' do
        before :each do
          shapefile.files.attach(
            io:  File.open(Rails.root.join('spec', 'fixtures', 'geoserver', 'gef_project.zip')),
            filename: 'gef_project.zip',
            content_type: 'application/zip'
          )
          @zip_file_path = "#{Rails.root}/tmp/#{shapefile.gef_project.gef_id}.zip"
        end

        it 'does not build or upload a file' do
          expect_any_instance_of(Geoserver::ZipFileBuilders::FromZipFile).to receive(:call).once.and_raise('error')
          expect_any_instance_of(Geoserver::ZipFileBuilders::FromShapeFiles).not_to receive(:call)
          expect_any_instance_of(Geoserver::ScpFileTransfer).not_to receive(:call)

          subject.call

          expect(shapefile.reload.status).to eq('upload_failed')
          expect(shapefile.shapefile_import_errors.count).to eq(1)
          expect(shapefile.shapefile_import_errors.pluck(:message)).to eq [I18n.t('services.shapefile_uploader.unknown_error')]
          expect(File.exist?(@zip_file_path)).to eq(false) # File created in the setup should have been deleted.
        end
      end

      context 'with shapefiles files' do
        before :each do
          %w[.shp .shx .dbf .prj].each do |extension|
            shapefile.files.attach(
              io:  File.open(Rails.root.join('spec', 'fixtures', 'geoserver', "gef_project#{extension}")),
              filename: "gef_project#{extension}",
              content_type: 'application/x-shapefile' # This differs by file extension but doesn't matter here.
            )
          end
          @zip_file_path = "#{Rails.root}/tmp/#{shapefile.gef_project.gef_id}.zip"
        end

        it 'does not build or upload a file' do
          expect_any_instance_of(Geoserver::ZipFileBuilders::FromShapeFiles).to receive(:call).once.and_raise('error')
          expect_any_instance_of(Geoserver::ZipFileBuilders::FromZipFile).not_to receive(:call)
          expect_any_instance_of(Geoserver::ScpFileTransfer).not_to receive(:call).once

          subject.call

          expect(shapefile.reload.status).to eq('upload_failed')
          expect(shapefile.shapefile_import_errors.count).to eq(1)
          expect(shapefile.shapefile_import_errors.pluck(:message)).to eq [I18n.t('services.shapefile_uploader.unknown_error')]
          expect(File.exist?(@zip_file_path)).to eq(false) # File created in the setup should have been deleted.
        end
      end
    end

    context 'scp transfer fails' do
      before :each do
        shapefile.files.attach(
          io:  File.open(Rails.root.join('spec', 'fixtures', 'geoserver', 'gef_project.zip')),
          filename: 'gef_project.zip',
          content_type: 'application/zip'
        )
        @zip_file_path = "#{Rails.root}/tmp/#{shapefile.gef_project.gef_id}.zip"
        File.write(@zip_file_path, 'zip file contents')
      end

      it 'deletes the .zip file in the tmp directory' do
        expect_any_instance_of(Geoserver::ZipFileBuilders::FromZipFile).to receive(:call).once.and_return(true)
        expect_any_instance_of(Geoserver::ZipFileBuilders::FromShapeFiles).not_to receive(:call)
        expect_any_instance_of(Geoserver::ScpFileTransfer).to receive(:call).and_return(false)

        subject.call

        expect(File.exist?(@zip_file_path)).to eq(false) # File created in the setup should have been deleted.
      end
    end
  end
end
