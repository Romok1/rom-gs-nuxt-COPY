require 'rails_helper'

RSpec.describe Indicators::PercentageProgress, type: :model do
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

      it 'returns the correct data' do
        indicator_chart_data = Indicators::PercentageProgress.new(IndicatorScore.all).call

        expect(indicator_chart_data.length).to eq GEFProject.count
        expect(indicator_chart_data.pluck(:gef_id)).to match_array GEFProject.pluck(:gef_id)

        gef_project_1_expected_progress = (gef_project_1_indicator_score_pir_2.value - gef_project_1_indicator_score_baseline.value) / (gef_project_1_indicator_score_expected.value - gef_project_1_indicator_score_baseline.value) * 100
        gef_project_2_expected_progress = (gef_project_2_indicator_score_pir.value - gef_project_2_indicator_score_baseline.value) / (gef_project_2_indicator_score_expected.value - gef_project_2_indicator_score_baseline.value) * 100
        gef_project_1_calculated_progress = indicator_chart_data.find do |gef_project_data|
                                              gef_project_data[:gef_id] == gef_project_1.gef_id
                                            end [:percentage_progress]

        gef_project_2_calculated_progress = indicator_chart_data.find do |gef_project_data|
          gef_project_data[:gef_id] == gef_project_2.gef_id
        end [:percentage_progress]

        expect(gef_project_1_calculated_progress).to eq gef_project_1_expected_progress
        expect(gef_project_2_calculated_progress).to eq gef_project_2_expected_progress
      end
    end
  end
end
