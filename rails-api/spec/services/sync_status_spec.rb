require 'rails_helper'

RSpec.describe SyncStatus, type: :model do
  describe 'when import is in progress' do
    context 'when a gef_project_import_is in progress' do
      let(:gef_project_import) { build(:gef_project_import, status: :processing, updated_at: DateTime.now) }
      let(:indicator_import) { build(:indicator_import, status: :completed, updated_at: DateTime.now) }

      it 'prevents a new import starting again' do
        allow(GEFProjectImport).to receive(:last_sync).and_return(gef_project_import)
        allow(IndicatorImport).to receive(:last_sync).and_return(indicator_import)
        expect(subject.should_sync_again?).to eq false
      end
    end

    context 'when an indicator_import is in progress' do
      let(:gef_project_import) { build(:gef_project_import, status: :completed, updated_at: DateTime.now) }
      let(:indicator_import) { build(:indicator_import, status: :processing, updated_at: DateTime.now) }

      it 'prevents a new import starting again' do
        allow(GEFProjectImport).to receive(:last_sync).and_return(gef_project_import)
        allow(IndicatorImport).to receive(:last_sync).and_return(indicator_import)
        expect(subject.should_sync_again?).to eq false
      end
    end
  end

  describe 'import state is in progress' do
    context 'imports are less than 10 minutes old' do
      let(:gef_project_import) { build(:gef_project_import, status: :processing, updated_at: DateTime.now) }
      let(:indicator_import) { build(:indicator_import, status: :processing, updated_at: DateTime.now) }

      it 'prevents a new import starting' do
        allow(GEFProjectImport).to receive(:last_sync).and_return(gef_project_import)
        allow(IndicatorImport).to receive(:last_sync).and_return(indicator_import)
        expect(subject.should_sync_again?).to eq false
      end
    end

    context 'imports are more than 10 minutes old' do
      let(:gef_project_import) do
        build(:gef_project_import, status: :processing, updated_at: DateTime.now - 11.minutes)
      end
      let(:indicator_import) { build(:indicator_import, status: :processing, updated_at: DateTime.now - 11.minutes) }

      it 'allows a new import' do
        allow(GEFProjectImport).to receive(:last_sync).and_return(gef_project_import)
        allow(IndicatorImport).to receive(:last_sync).and_return(indicator_import)
        expect(subject.should_sync_again?).to eq true
      end
    end
  end
end
