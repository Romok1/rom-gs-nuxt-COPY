require 'rails_helper'

RSpec.describe Importers::Sharepoint, type: :model do
  describe '#call' do
    subject { described_class.new(import) }

    let!(:import) { create(:gef_project_import, updated_at: DateTime.now, status: :pending) }
    let(:file_location) { 'tmp/some_date.xlsx' }

    before :each do
      # Write a file to test it gets deleted.
      File.new file_location, 'w'
    end

    after :each do
      # Clean up any tmp files created by the test.
      File.delete(file_location) if File.exist?(file_location)
    end

    context 'with no exception raised' do
      it 'runs the import, updates the import status to :completed, and deletes the downloaded file' do
        expect_any_instance_of(Sharepoint::FileDownload).to receive(:call).once.and_return(file_location)
        expect_any_instance_of(Importers::Xlsx).to receive(:call).once

        subject.call

        expect(import.reload.status).to eq 'completed'
        expect(File.exist?(file_location)).to eq false # Deletes sharepoint file.
      end
    end

    context 'with exception raised' do
      it 'updates the import status to :failed, and deletes the downloaded file' do
        expect_any_instance_of(Sharepoint::FileDownload).to receive(:call).once.and_return(file_location)
        expect_any_instance_of(Importers::Xlsx).to receive(:call).and_raise(StandardError)

        subject.call

        expect(import.reload.status).to eq 'failed'
        expect(import.import_errors.count).to eq 1
        expect(File.exist?(file_location)).to eq false # Deletes sharepoint file.
      end
    end
  end
end
