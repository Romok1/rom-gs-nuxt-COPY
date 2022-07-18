require 'rails_helper'

RSpec.describe Mappers::GEFProject, type: :model do
  let(:spreadsheet_row_hash) do
    {
      gef_id: 'an id',
      title: 'test project',
      implementing_agencies: '',
      countries: '',
      regions: '',
      short_title: '',
      task_manager: '',
      current_status: '',
      pa_focal_point: '',
      fmo: '',
      project_grant: '',
      fa_focal_point: '',
      mid_term_evaluation_status: '',
      terminal_evaluation_status: '',
      project_closed_date: '',
      focal_areas: '',
      unep_signature_date: '',
      pif_approval_date: '',
      project_endorsement_date: '',
      expected_completion_date: '',
      revised_completion_date: '',
      actual_completion_date: ''
    }
  end

  # Create default db records we need for the importer
  let!(:roles) do
    create(:role, name: 'Task Manager')
    create(:role, name: 'FMO')
    create(:role, name: 'PA Focal Point')
    create(:role, name: 'FA Focal Point')
  end

  let!(:timeline_event) do
    create(:timeline_event, name: 'Received by GEF')
    create(:timeline_event, name: 'Concept Approved')
    create(:timeline_event, name: 'Project Approved for Implementation')
    create(:timeline_event, name: 'Project Closed')
  end

  describe '#call' do
    context 'with valid data' do
      context 'without associations' do
        let!(:gef_project) { GEFProject.create(gef_id: 'A GEF ID', title: 'test project') }

        it 'generates a hash and doesn\'t add errors' do
          gef_project_attrs = Mappers::GEFProject.new(gef_project, spreadsheet_row_hash).call

          expect(gef_project_attrs.keys).to match_array %i[
            title short_title current_status project_grant mid_term_evaluation_status
            terminal_evaluation_status gef_projects_users_attributes georegion_ids
            implementing_agency_ids focal_area_ids gef_projects_timeline_events_attributes
          ]
          expect(gef_project.update(gef_project_attrs)).to eq true
        end
      end

      context 'Georegions' do
        let!(:mauritania) { create(:country, name: 'Mauritania', iso: 'MAU') }
        let!(:georegions) do
          create(:country, name: 'Senegal', iso: 'SEN', georegion_type: mauritania.georegion_type)
          create(:country, name: 'Mali', iso: 'MAL', georegion_type: mauritania.georegion_type)
          africa = create(:region, name: 'Africa')
          create(:region, name: 'Asia', georegion_type: africa.georegion_type)
        end

        # a gef_project with one georegion
        let!(:gef_project) { GEFProject.create(gef_id: 'A GEF ID', title: 'test project', georegions: [mauritania]) }

        it 'adds Georegions' do
          # row fields with three different georegions from the gef_project
          spreadsheet_row_hash_with_georegions = spreadsheet_row_hash.merge({
            countries: 'Regional (Senegal, Mali)',
            regions: 'Africa'
          })

          gef_project_attrs = Mappers::GEFProject.new(gef_project, spreadsheet_row_hash_with_georegions).call
          expect(gef_project.update(gef_project_attrs)).to eq true
          expect(gef_project.georegions.count).to eq 3
          expect(gef_project.georegions.pluck(:name)).to match_array %w[Senegal Mali Africa]
        end
      end

      context 'Users' do
        let(:user) { create(:user, name: 'test user') }
        let(:task_manager_role) { Role.find_by(name: 'Task Manager') }

        # a gef_project with a task manager
        let(:gef_project) { create(:gef_project_with_user_with_role, user:, role: task_manager_role) }

        it 'adds Users' do
          # row fields with a different task manager from the gef_project and some extra users in other roles
          spreadsheet_row_hash_with_users = spreadsheet_row_hash.merge({
            task_manager: 'Task manager user',
            pa_focal_point: 'PA focal point user',
            fmo: 'FMO user',
            fa_focal_point: 'FA Focal point user'
          })
          gef_project_attrs = Mappers::GEFProject.new(gef_project, spreadsheet_row_hash_with_users).call
          expect(gef_project.update(gef_project_attrs)).to eq true
          expect(gef_project.users.count).to eq 4
          expect(gef_project.task_manager.name).to eq spreadsheet_row_hash_with_users[:task_manager]
          expect(gef_project.pa_focal_point.name).to eq spreadsheet_row_hash_with_users[:pa_focal_point]
          expect(gef_project.fmo.name).to eq spreadsheet_row_hash_with_users[:fmo]
          expect(gef_project.fa_focal_point.name).to eq spreadsheet_row_hash_with_users[:fa_focal_point]
        end
      end

      context 'TimelineEvents' do
        let(:gef_project) { create(:gef_project) }

        it 'adds TimelineEvents' do
          date_attributes = {
            pif_approval_date: Date.new(2020, 1, 1),
            project_endorsement_date: '',
            revised_completion_date: Date.new(2025, 1, 1)
          }
          spreadsheet_row_hash_with_timeline_event_dates = spreadsheet_row_hash.merge(date_attributes)
          gef_project_attrs = Mappers::GEFProject.new(gef_project, spreadsheet_row_hash_with_timeline_event_dates).call
          expect(gef_project.update(gef_project_attrs)).to eq true
          expect(gef_project.timeline_events.count).to eq 2
        end
      end
    end

    context 'with invalid data' do
      let!(:gef_project) { GEFProject.create(gef_id: 'A GEF ID', title: 'test project') }

      context 'Georegions' do
        it 'returns an error' do
          spreadsheet_row_hash_with_georegions = spreadsheet_row_hash.merge({
            countries: 'Narnia, Mordor)'
          })

          gef_project_attrs = Mappers::GEFProject.new(gef_project, spreadsheet_row_hash_with_georegions).call
          expect(gef_project.errors.count).to eq 2
        end
      end

      context 'TimelineEvents' do
        context 'adds TimelineEvents' do
          it 'returns an error' do
            spreadsheet_row_hash_with_dates = spreadsheet_row_hash.merge({
              project_endorsement_date: 'This is not a date'
            })
            gef_project_attrs = Mappers::GEFProject.new(gef_project, spreadsheet_row_hash_with_dates).call
            expect(gef_project.errors.count).to eq 1
          end
        end
      end
    end
  end
end
