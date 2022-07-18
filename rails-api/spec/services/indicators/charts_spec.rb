require 'rails_helper'

RSpec.describe Indicators::Charts, type: :model do
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
        indicator_chart_data = Indicators::Charts.new(IndicatorScore.all).call

        expect(indicator_chart_data.keys).to match_array %i[expected projects_assessed indicator_values years]

        expect(indicator_chart_data[:expected]).to eq(IndicatorScore.where(assessment_type: 'expected_results').sum(:value))
        expect(indicator_chart_data[:years]).to eq (IndicatorScore.pluck(:year).min..IndicatorScore.pluck(:year).max).to_a
        expect(indicator_chart_data[:projects_assessed]).to eq [0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2]
        expect(indicator_chart_data[:indicator_values]).to eq [90.0, 103.0, 103.0, 103.0, 103.0, 103.0, 118.0, 118.0,
          118.0, 118.0, 3588.0]
      end
    end
  end
end
