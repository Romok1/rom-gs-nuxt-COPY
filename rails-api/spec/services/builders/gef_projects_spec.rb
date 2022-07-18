require 'rails_helper'

RSpec.describe Builders::GEFProjects, type: :model do
  let(:errors) { [] }
  let(:new_title) { 'A brand new title' }

  subject { described_class.new(gef_id, rows, errors) }

  describe '#call' do
    context 'with valid data' do
      let(:rows) do
        [
          { row_number: 1,
            row_hash: { gef_id: 'a new gef id', title: new_title, current_status: 'Under Implementation' } }
        ]
      end

      context 'for an existing GEF Project' do
        let!(:gef_project) { create(:gef_project) }
        let(:gef_id) { gef_project.gef_id }
        let!(:gef_project_import) { create(:gef_project_import) }
        let!(:gef_project_import_errors) do
          create_list(:gef_project_import_error, 2, gef_project:, gef_project_import:)
        end

        it 'updates the gef project' do
          expect { subject.call }.not_to change(GEFProject, :count)
          expect(errors).to be_empty
          expect(gef_project.reload.title).to eq(new_title)
          expect(gef_project.gef_project_import_errors).to be_empty
        end
      end

      context 'for a new GEF Project' do
        let(:gef_id) { 'a new gef id' }

        it 'creates the gef project' do
          expect { subject.call }.to change(GEFProject, :count).by(1)
          expect(errors).to be_empty
        end
      end
    end

    context 'with invalid data' do
      context 'with a current_status that shouldn\'t be imported' do
        let(:rows) do
          [
            { row_number: 1,
              row_hash: { gef_id: 'a new gef id', title: new_title, current_status: 'should not be imported' } }
          ]
        end

        context 'for a new GEF Project' do
          let(:gef_id) { 'a new gef id' }

          it 'does not create the gef project' do
            expect { subject.call }.not_to change(GEFProject, :count)
            expect(errors).to be_empty
          end
        end
      end

      context 'with multiple rows' do
        let(:gef_id) { 'a new gef id' }
        let(:rows) do
          [
            { row_number: 1, row_hash: { gef_id:, title: new_title } },
            { row_number: 2, row_hash: { gef_id:, title: new_title } }
          ]
        end

        it 'adds errors and builds the first row' do
          expect { subject.call }.to change(GEFProject, :count).by(1)
          gef_project_id = GEFProject.find_by_gef_id(gef_id).id
          expect(errors).to match_array(
            [
              { gef_project_id:, message: I18n.t('imports.import_errors.gef_project.duplicated'),
                row_number: 1 },
              { gef_project_id:, message: I18n.t('imports.import_errors.gef_project.duplicated'),
                row_number: 2 }
            ]
          )
          expect(GEFProject.first.title).to eq(new_title)
        end
      end
    end
  end
end
