require 'rails_helper'

RSpec.describe Mappers::Indicator, type: :model do
  let(:spreadsheet_row_hash) do
    {
      gef_id: 'an id',
      project_title: 'test project',
      task_manager: '',
      timeline: '',
      pir_year: '',
      core_indicator: '',
      core_indicator_value: '',
      sub_indicator: '',
      sub_indicator_value: ''
    }
  end

  describe '#call' do
    context 'with valid data' do
      context 'existing indicators' do
        let!(:gef_core_indicator_type) { create(:gef_core_indicator_type) }
        let!(:gef_project) { GEFProject.create(gef_id: 'A GEF ID', title: 'test project') }

        let!(:start_date) { create(:timeline_event, name: ::TimelineEvent.event_name(:project_start_date)) }
        let!(:technical_completion_date) do
          create(:timeline_event, name: ::TimelineEvent.event_name(:technical_completion_date))
        end
        let!(:start_date_event) do
          create(:gef_projects_timeline_event, gef_project:, timeline_event: start_date, date: DateTime.now - 5.years)
        end
        let!(:end_date_event) do
          create(:gef_projects_timeline_event, gef_project:, timeline_event: technical_completion_date,
            date: DateTime.now + 5.years)
        end

        let!(:core_indicator) { create(:indicator, indicator_type: gef_core_indicator_type) }
        let!(:sub_indicator) do
          create(:indicator, indicator_type: gef_core_indicator_type, parent_id: core_indicator.id)
        end

        context 'Core indicators' do
          it 'adds an indicator score for the indicator' do
            spreadsheet_row_hash_with_core_indicator = spreadsheet_row_hash.merge({
              core_indicator: core_indicator.name,
              core_indicator_value: 100,
              timeline: 'Baseline'
            })

            gef_project_attrs = Mappers::Indicator.new(gef_project, spreadsheet_row_hash_with_core_indicator).call
            expect(gef_project.update(gef_project_attrs)).to eq true
            expect(gef_project.indicator_scores.count).to eq 1
            indicator_score = gef_project.indicator_scores.first
            expect(indicator_score.indicator.name).to eq core_indicator.name
            expect(indicator_score.value).to eq spreadsheet_row_hash_with_core_indicator.dig(:core_indicator_value)
            expect(indicator_score.assessment_type).to eq spreadsheet_row_hash_with_core_indicator.dig(:timeline).downcase
          end
        end

        context 'Sub-core indicators' do
          it 'adds an indicator score for the indicator' do
            spreadsheet_row_hash_with_sub_indicator = spreadsheet_row_hash.merge({
              core_indicator: core_indicator.name,
              sub_indicator: sub_indicator.name,
              sub_indicator_value: '100',
              timeline: 'Baseline'
            })

            gef_project_attrs = Mappers::Indicator.new(gef_project, spreadsheet_row_hash_with_sub_indicator).call
            expect(gef_project.update(gef_project_attrs)).to eq true
            expect(gef_project.indicator_scores.count).to eq 1

            indicator_score = gef_project.indicator_scores.first
            expect(indicator_score.indicator.name).to eq sub_indicator.name
            expect(indicator_score.value).to eq spreadsheet_row_hash_with_sub_indicator.dig(:sub_indicator_value).to_i
            expect(indicator_score.assessment_type).to eq spreadsheet_row_hash_with_sub_indicator.dig(:timeline).downcase
          end
        end
      end

      context 'indicators not in database' do
        let!(:gef_core_indicator_type) { create(:gef_core_indicator_type) }
        let!(:gef_project) { GEFProject.create(gef_id: 'A GEF ID', title: 'test project') }
        let!(:core_indicator) { create(:indicator, indicator_type: gef_core_indicator_type) }

        let!(:start_date) { create(:timeline_event, name: ::TimelineEvent.event_name(:project_start_date)) }
        let!(:technical_completion_date) do
          create(:timeline_event, name: ::TimelineEvent.event_name(:technical_completion_date))
        end
        let!(:start_date_event) do
          create(:gef_projects_timeline_event, gef_project:, timeline_event: start_date, date: DateTime.now - 5.years)
        end
        let!(:end_date_event) do
          create(:gef_projects_timeline_event, gef_project:, timeline_event: technical_completion_date,
            date: DateTime.now + 5.years)
        end

        it 'creates the core-indicator' do
          spreadsheet_row_hash_with_core_indicator = spreadsheet_row_hash.merge({
            core_indicator: 'test core indicator',
            core_indicator_value: '100',
            timeline: 'Baseline'
          })

          expect do
            Mappers::Indicator.new(gef_project, spreadsheet_row_hash_with_core_indicator).call
          end.to change { Indicator.count }.by(1)
          expect(Indicator.last.name).to eq(spreadsheet_row_hash_with_core_indicator.dig(:core_indicator))
        end

        it 'creates the sub-core indicator' do
          spreadsheet_row_hash_with_sub_indicator = spreadsheet_row_hash.merge({
            core_indicator: core_indicator.name,
            sub_indicator: 'test sub-core indicator name',
            sub_indicator_value: '100',
            timeline: 'Baseline'
          })

          expect do
            Mappers::Indicator.new(gef_project, spreadsheet_row_hash_with_sub_indicator).call
          end.to change { Indicator.count }.by(1)
          expect(Indicator.last.name).to eq(spreadsheet_row_hash_with_sub_indicator.dig(:sub_indicator))
        end

        it 'creates the indicator and sub-core indicator' do
          spreadsheet_row_hash_with_sub_and_core_indicator = spreadsheet_row_hash.merge({
            core_indicator: 'test core indicator name',
            sub_indicator: 'test sub-core indicator name',
            sub_indicator_value: 100,
            timeline: 'Baseline'
          })

          expect do
            Mappers::Indicator.new(gef_project, spreadsheet_row_hash_with_sub_and_core_indicator).call
          end.to change { Indicator.count }.by(2)

          expect(Indicator.pluck(:name)).to match_array(
            [
              spreadsheet_row_hash_with_sub_and_core_indicator.dig(:sub_indicator),
              spreadsheet_row_hash_with_sub_and_core_indicator.dig(:core_indicator),
              core_indicator.name
            ]
          )
        end
      end
    end

    context 'with invalid data' do
      let!(:gef_core_indicator_type) { create(:gef_core_indicator_type) }
      let!(:gef_project) { GEFProject.create(gef_id: 'A GEF ID', title: 'test project') }
      let!(:core_indicator) { create(:indicator, indicator_type: gef_core_indicator_type) }

      let!(:start_date) { create(:timeline_event, name: ::TimelineEvent.event_name(:project_start_date)) }
      let!(:technical_completion_date) do
        create(:timeline_event, name: ::TimelineEvent.event_name(:technical_completion_date))
      end
      let!(:start_date_event) do
        create(:gef_projects_timeline_event, gef_project:, timeline_event: start_date, date: DateTime.now - 5.years)
      end
      let!(:end_date_event) do
        create(:gef_projects_timeline_event, gef_project:, timeline_event: technical_completion_date,
          date: DateTime.now + 5.years)
      end

      context 'no indicator names present' do
        it 'returns an error' do
          expect do
            Mappers::Indicator.new(gef_project, spreadsheet_row_hash).call
          end.not_to change { Indicator.count }

          expect(gef_project.errors.full_messages).to match_array [I18n.t('imports.import_errors.indicator.indicator_names_missing')]
        end
      end

      context 'no indicator values present' do
        it 'returns an error' do
          spreadsheet_row_hash_with_no_indicator_values = spreadsheet_row_hash.merge({
            core_indicator: 'test core indicator name',
            sub_indicator: 'test sub-core indicator name',
            timeline: 'Baseline'
          })

          Mappers::Indicator.new(gef_project, spreadsheet_row_hash_with_no_indicator_values).call
          expect(gef_project.errors.full_messages).to match_array [I18n.t('imports.import_errors.indicator.value_missing')]
        end
      end

      context 'both core-indicator and sub-core indicator values present' do
        it 'returns an error' do
          spreadsheet_row_hash_with_core_and_sub_indicator_values = spreadsheet_row_hash.merge({
            core_indicator: 'test core indicator name',
            core_indicator_value: '100',
            sub_indicator: 'test sub-core indicator name',
            sub_indicator_value: '100',
            timeline: 'Baseline'
          })

          Mappers::Indicator.new(gef_project, spreadsheet_row_hash_with_core_and_sub_indicator_values).call
          expect(gef_project.errors.full_messages).to match_array [I18n.t('imports.import_errors.indicator.core_and_subindicator_values_present')]
        end
      end

      context 'Insufficient date information on project to determine a year' do
        let!(:gef_project_2) { create(:gef_project) }

        it 'returns an error' do
          spreadsheet_row_hash_with_core_and_sub_indicator_values = spreadsheet_row_hash.merge({
            sub_indicator: 'test sub-core indicator name',
            sub_indicator_value: '100',
            timeline: 'Baseline'
          })

          Mappers::Indicator.new(gef_project_2, spreadsheet_row_hash_with_core_and_sub_indicator_values).call
          expect(gef_project_2.errors.full_messages).to match_array [I18n.t('imports.import_errors.indicator.year_missing')]
        end
      end
    end
  end
end
