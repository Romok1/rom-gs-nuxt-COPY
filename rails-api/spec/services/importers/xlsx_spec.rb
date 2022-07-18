require 'rails_helper'

RSpec.describe Importers::Xlsx, type: :model do
  subject { described_class.new(gef_project_import, import_errors) }
  let(:gef_project_import) { create(:gef_project_import, updated_at: DateTime.now, status: :pending) }
  let(:import_errors) { [] }

  describe '#call' do
    context 'with invalid data' do
      context 'invalid headers' do
        it 'returns an error for each missing header' do
          allow(gef_project_import).to receive(:spreadsheet_filename).and_return('gef_projects_with_2_bad_headers.xlsx')
          subject.call
          expect(import_errors.count).to eq 2
          expect(gef_project_import.persisted?).to eq true
          expect(import_errors.pluck(:row_number).uniq).to match [1]
        end
      end
    end

    context 'with valid data' do
      # Create default db records we need for the importer
      let!(:roles) do
        create(:role, name: 'Task Manager')
        create(:role, name: 'FMO')
        create(:role, name: 'PA Focal Point')
        create(:role, name: 'FA Focal Point')
      end

      let!(:georegions) do
        mauritania = create(:country, name: 'Mauritania', iso: 'MAU')
        create(:country, name: 'Senegal', iso: 'SEN', georegion_type: mauritania.georegion_type)
        create(:country, name: 'Mali', iso: 'MAL', georegion_type: mauritania.georegion_type)
        africa = create(:region, name: 'Africa')
        create(:region, name: 'Asia', georegion_type: africa.georegion_type)
      end

      let!(:implementing_agencies) do
        create(:implementing_agency, name: 'UNEP')
        create(:implementing_agency, name: 'UNDP')
        create(:implementing_agency, name: 'FAO')
      end

      let!(:focal_areas) do
        create(:focal_area, name: 'Biodiversity')
        create(:focal_area, name: 'CCM')
      end

      let!(:timeline_event) do
        create(:timeline_event, name: 'Expected Technical Completion')
        create(:timeline_event, name: 'Revised Technical Completion')
        create(:timeline_event, name: 'Actual Technical Completion')
        create(:timeline_event, name: 'Received by GEF')
        create(:timeline_event, name: 'Concept Approved')
        create(:timeline_event, name: 'Project Approved for Implementation')
        create(:timeline_event, name: 'Project Closed')
      end

      context 'creating a GEFProject' do
        it 'creates a project and doesn\'t raise errors' do
          allow(gef_project_import).to receive(:spreadsheet_filename).and_return('one_gef_project.xlsx')

          subject.call

          expect(import_errors.count).to eq 0
          expect(GEFProject.count).to eq 1

          gef_project = GEFProject.first
          expect(gef_project.georegions.pluck(:name)).to match %w[Mauritania Senegal Africa]
          expect(gef_project.users.count).to eq 3
          expect(gef_project.users.pluck(:name)).to match ['BD/LD Unit', 'FA focal point user', 'PA Focal Point user']
          expect(gef_project.focal_areas.pluck(:name)).to match %w[Biodiversity]
          expect(gef_project.implementing_agencies.pluck(:name)).to match %w[UNEP UNDP]
        end
      end

      context 'updating a GEFProject' do
        it 'updates a project and doesn\'t raise errors' do
          expect(gef_project_import).not_to receive(:send_error_notification)

          allow(gef_project_import).to receive(:spreadsheet_filename).and_return('one_gef_project.xlsx')
          subject.call

          allow(gef_project_import).to receive(:spreadsheet_filename).and_return('gef_projects_for_update.xlsx')
          subject.call

          expect(gef_project_import.gef_project_import_errors.count).to eq 0
          expect(gef_project_import.persisted?).to eq true
          expect(GEFProject.count).to eq 1

          gef_project = GEFProject.first
          expect(gef_project.georegions.pluck(:name)).to match %w[Senegal Mali Africa Asia]
          expect(gef_project.users.count).to eq 2

          expect(gef_project.users.pluck(:name)).to match ['New user', 'New FA focal point user']
          expect(gef_project.focal_areas.pluck(:name)).to match %w[CCM]
          expect(gef_project.implementing_agencies.pluck(:name)).to match %w[FAO]
        end
      end
    end
  end
end
