require 'rails_helper'

RSpec.describe Geoserver::ScpFileTransfer, type: :model do
  let(:errors) { [] }
  let(:gef_project_gef_id) { 'gef_project_gef_id' }
  let(:zip_file_path) { 'zip_file_path' }

  subject { Geoserver::ScpFileTransfer.new(gef_project_gef_id, zip_file_path, errors) }

  context 'valid data' do
    it 'calls Net::SCP.upload! and does not return errors' do
      expect(Net::SCP).to receive(:upload!).and_return(true).once
      expect(Net::SSH).to receive(:start).and_return(true).once
      expect(subject.call).to eq(true)
      expect(errors).to eq([])
    end
  end

  context 'with invalid data' do
    it 'calls Net::SCP.upload! and returns the error' do
      error = 'Net::SCP error'
      allow(Net::SCP).to receive(:upload!).and_raise(error)
      expect(subject.call).to eq(false)
      expect(errors).to eq([error])
    end
  end
end
