require 'rails_helper'

RSpec.describe Builders::Indicators, type: :model do
  let(:errors) { [] }

  subject { described_class.new(gef_id, rows, errors) }

  describe '#call' do
    context 'with valid data' do
      let(:core_indicator) { create(:indicator) }
      let(:sub_indicator) { create(:indicator, parent_id: core_indicator.id) }
      let(:core_indicator_value) { 100 }
      let(:sub_indicator_value) { 30 }

      let(:rows) do
        [
          {
            row_number: 1,
            row_hash: {
              gef_id: 'a new gef id',
              title: 'new_title',
              core_indicator: core_indicator.name,
              core_indicator_value:,
              timeline: 'Baseline'
            }
          },
          {
            row_number: 2,
            row_hash: {
              gef_id: 'a new gef id',
              title: 'new_title',
              core_indicator: core_indicator.name,
              core_indicator_value:,
              timeline: 'Expected Results'
            }
          }
        ]
      end

      context 'for an existing GEF Project' do
        let!(:gef_project) { create(:gef_project) }
        let!(:existing_indicator_score) { create(:indicator_score, gef_project:, year: 'Expected', value: 999) }
        let(:gef_id) { gef_project.gef_id }
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

        let!(:indicator_import) { create(:indicator_import) }
        let!(:indicator_import_errors) do
          create_list(:indicator_import_error, 2, gef_project:, indicator_import:)
        end

        it 'updates the indicator scores to match the row data' do
          expect(gef_project.reload.indicator_score_ids).to include(existing_indicator_score.id)
          subject.call
          expect(errors).to be_empty
          expect(gef_project.reload.indicator_scores.count).to eq(2)
          expect(gef_project.reload.indicator_score_ids).not_to include(existing_indicator_score.id)
        end

        # Missing baselines are considered to be 0, so do not affect summaries.
        it 'imports indicator_scores when Baseline is missing' do
          rows.first[:row_hash][:timeline] = 'PIR Year'
          expect(gef_project.reload.indicator_score_ids).to include(existing_indicator_score.id)
          subject.call
          expect(errors.length).to be(0)
          expect(gef_project.reload.indicator_scores.count).to eq(2)
        end
      end
    end

    context 'with invalid data' do
      let(:core_indicator) { create(:indicator) }
      let(:sub_indicator) { create(:indicator, parent_id: core_indicator.id) }
      let(:core_indicator_value) { 100 }
      let(:sub_indicator_value) { 30 }

      let(:rows) do
        [
          {
            row_number: 1,
            row_hash: {
              gef_id: 'a new gef id',
              title: 'new_title',
              core_indicator: core_indicator.name,
              core_indicator_value:,
              timeline: 'Baseline'
            }
          },
          {
            row_number: 2,
            row_hash: {
              gef_id: 'a new gef id',
              title: 'new_title',
              core_indicator: core_indicator.name,
              core_indicator_value:,
              timeline: 'Expected Results'
            }
          }
        ]
      end

      context 'for an existing GEF Project' do
        let!(:gef_project) { create(:gef_project) }
        let!(:existing_indicator_score) { create(:indicator_score, gef_project:, year: 'Expected', value: 999) }
        let(:gef_id) { gef_project.gef_id }
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

        let!(:indicator_import) { create(:indicator_import) }
        let!(:indicator_import_errors) do
          create_list(:indicator_import_error, 2, gef_project:, indicator_import:)
        end

        it 'does not add indicator_scores when Expected Results are missing' do
          rows.last[:row_hash][:timeline] = 'PIR Year'
          expect(gef_project.reload.indicator_score_ids).to include(existing_indicator_score.id)
          subject.call
          expect(errors.length).to eq rows.length
          expect(errors.pluck(:message).uniq).to eq [I18n.t('imports.import_errors.indicator.missing_expected_results',
            indicator_name: core_indicator.name)]
          expect(gef_project.reload.indicator_scores.count).to eq(0)
        end

        it 'does not add indicator_scores when project dates are missing' do
          gef_project.timeline_events.destroy_all
          expect(gef_project.reload.indicator_score_ids).to include(existing_indicator_score.id)
          subject.call
          expect(errors.length).to eq rows.length
          expect(errors.pluck(:message).uniq).to eq [I18n.t('imports.import_errors.indicator.year_missing')]
          expect(gef_project.reload.indicator_scores.count).to eq(0)
        end
      end
    end
  end
end
