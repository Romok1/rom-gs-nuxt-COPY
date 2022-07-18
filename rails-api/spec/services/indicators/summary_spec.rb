require 'rails_helper'

RSpec.describe Indicators::Summary, type: :model do
  describe '#call' do
    context 'with valid data' do
      let!(:gef_project_1) { create(:gef_project) }
      let!(:gef_project_2) { create(:gef_project) }
      let!(:gef_core_indicator_type) { create(:gef_core_indicator_type) }
      let!(:indicator) { create(:indicator, indicator_type: gef_core_indicator_type) }

      let!(:gef_project_1_indicator_score_baseline) do
        create(:indicator_score, indicator:, year: 2016, gef_project: gef_project_1, value: 15,
          assessment_type: 'baseline')
      end
      let!(:gef_project_1_indicator_score_pir_1) do
        create(:indicator_score, indicator:, year: 2020, gef_project: gef_project_1, value: 30,
          assessment_type: 'pir_year')
      end
      let!(:gef_project_1_indicator_score_pir_2) do
        create(:indicator_score, indicator:, year: 2024, gef_project: gef_project_1, value: 3500,
          assessment_type: 'pir_year')
      end
      let!(:gef_project_1_indicator_score_expected) do
        create(:indicator_score, indicator:, year: 2025, gef_project: gef_project_1, value: 7000,
          assessment_type: 'expected_results')
      end

      let!(:gef_project_2_indicator_score_baseline) do
        create(:indicator_score, indicator:, year: 2014, gef_project: gef_project_2, value: 75,
          assessment_type: 'baseline')
      end
      let!(:gef_project_2_indicator_score_pir) do
        create(:indicator_score, indicator:, year: 2015, gef_project: gef_project_2, value: 88,
          assessment_type: 'pir_year')
      end
      let!(:gef_project_2_indicator_score_expected) do
        create(:indicator_score, indicator:, year: 2022, gef_project: gef_project_2, value: 8000,
          assessment_type: 'expected_results')
      end

      before :example do
        @charts_service = instance_double('Indicator::Charts')
        expect(@charts_service).to receive(:call).and_return nil

        @percentage_progress = instance_double('Indicator::PercentageProgress')
        expect(@percentage_progress).to receive(:call).and_return nil
      end

      context 'filtering by date' do
        it 'calls additional services with correct indicator_scores' do
          expect(Indicators::Charts).to receive(:new) do |indicator_scores|
            expect(indicator_scores.pluck(:id)).to match_array IndicatorScore.pluck(:id)
          end
            .and_return(@charts_service)

          expect(Indicators::PercentageProgress).to receive(:new) do |indicator_scores|
            expect(indicator_scores.pluck(:id)).to match_array IndicatorScore.pluck(:id)
          end
            .and_return(@percentage_progress)

          # Date range that overlaps both gef_projects.
          date_range = [2020, 2021]
          Indicators::Summary.new(indicator_id: indicator.id, date_range:, gef_project_ids: GEFProject.pluck(:id)).call
        end

        it 'excludes data for projects not coinciding with the date range' do
          expect(Indicators::Charts).to receive(:new) do |indicator_scores|
            expect(indicator_scores.pluck(:id)).to match_array gef_project_2.indicator_score_ids
          end
            .and_return(@charts_service)

          expect(Indicators::PercentageProgress).to receive(:new) do |indicator_scores|
            expect(indicator_scores.pluck(:id)).to match_array gef_project_2.indicator_score_ids
          end
            .and_return(@percentage_progress)

          # Date range that overlaps gef_project_2 but not gef_project_1.
          date_range = [2010, 2015]
          Indicators::Summary.new(indicator_id: indicator.id, date_range:, gef_project_ids: GEFProject.pluck(:id)).call
        end
      end

      context 'filters by gef_project_ids' do
        let!(:gef_project_3) { create(:gef_project) }
        let!(:gef_project_4) { create(:gef_project) }
        let!(:gef_project_3_indicator_score_baseline) do
          create(:indicator_score, indicator:, year: 2014, gef_project: gef_project_3, value: 300,
            assessment_type: 'baseline')
        end
        let!(:gef_project_3_indicator_score_pir_year) do
          create(:indicator_score, indicator:, year: 2015, gef_project: gef_project_3, value: 600,
            assessment_type: 'pir_year')
        end
        let!(:gef_project_3_indicator_score_expected) do
          create(:indicator_score, indicator:, year: 2022, gef_project: gef_project_3, value: 999,
            assessment_type: 'expected_results')
        end
        let!(:gef_project_4_indicator_score_baseline) do
          create(:indicator_score, indicator:, year: 2014, gef_project: gef_project_4, value: 500,
            assessment_type: 'baseline')
        end
        let!(:gef_project_4_indicator_score_expected) do
          create(:indicator_score, indicator:, year: 2022, gef_project: gef_project_4, value: 1234,
            assessment_type: 'expected_results')
        end
        let(:expected_project_counts) { [0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2] }
        let(:expected_indicator_scores) do
          [315.0, 615.0, 615.0, 615.0, 615.0, 615.0, 630.0, 630.0, 630.0, 630.0, 4100.0]
        end

        it 'only returns data for the gef_project_ids passed in' do
          expect(Indicators::Charts).to receive(:new) do |indicator_scores|
            expect(indicator_scores.pluck(:id)).to match_array IndicatorScore.where(gef_project_id: [gef_project_1,
              gef_project_3]).pluck(:id)
          end
            .and_return(@charts_service)

          expect(Indicators::PercentageProgress).to receive(:new) do |indicator_scores|
            expect(indicator_scores.pluck(:id)).to match_array IndicatorScore.where(gef_project_id: [gef_project_1,
              gef_project_3]).pluck(:id)
          end
            .and_return(@percentage_progress)

          Indicators::Summary.new(indicator_id: indicator.id,
            gef_project_ids: [gef_project_1, gef_project_3]).call
        end

        it 'filters by gef_project_ids and date' do
          expect(Indicators::Charts).to receive(:new) do |indicator_scores|
            expect(indicator_scores.pluck(:id)).to match_array IndicatorScore.where(gef_project_id: [gef_project_1,
              gef_project_3]).pluck(:id)
          end
            .and_return(@charts_service)

          expect(Indicators::PercentageProgress).to receive(:new) do |indicator_scores|
            expect(indicator_scores.pluck(:id)).to match_array IndicatorScore.where(gef_project_id: [gef_project_1,
              gef_project_3]).pluck(:id)
          end
            .and_return(@percentage_progress)

          indicator_chart_data = Indicators::Summary.new(indicator_id: indicator.id, date_range: [2016, 2019],
            gef_project_ids: [gef_project_1, gef_project_3]).call
          IndicatorScore.where(gef_project_id: [gef_project_1, gef_project_3])
        end
      end
    end

    context 'with no GEF Projects having assessments for an indicator' do
      let!(:gef_core_indicator_type) { create(:gef_core_indicator_type) }
      let!(:indicator) { create(:indicator, indicator_type: gef_core_indicator_type) }

      context 'invalid headers' do
        it 'returns a hash without data' do
          expect_any_instance_of(Indicators::PercentageProgress).not_to receive(:call)

          indicator_summary_hash = Indicators::Summary.new(indicator_id: indicator.id,
            gef_project_ids: GEFProject.pluck(:id)).call

          expect(indicator_summary_hash.keys)
            .to match_array(%i[id chart_data percentage_progress filtered_gef_ids])
          expect(indicator_summary_hash[:id]).to eq(indicator.id)
          expect(indicator_summary_hash[:percentage_progress]).to be_empty
          expect(indicator_summary_hash[:filtered_gef_ids]).to be_empty
        end
      end
    end
  end
end
