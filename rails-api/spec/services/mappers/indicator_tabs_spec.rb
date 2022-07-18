require 'rails_helper'

RSpec.describe Mappers::IndicatorTabs, type: :model do
  subject { Mappers::IndicatorTabs.new(gef_project) }

  describe '#call' do
    context 'existing indicators' do
      let!(:focal_areas) { create_list(:focal_area, 2) }
      let!(:gef_project) { create(:gef_project, focal_area_ids: focal_areas.pluck(:id)) }
      let!(:indicator_scores) { create_list(:indicator_score, 3, gef_project:, value: 0) }

      # indicators and focal areas not linked to the project
      let!(:focal_area) { create(:focal_area) }
      let!(:indicator) { create(:indicator) }

      it 'returns an object with the indicators and focal areas for the GEF Project' do
        json = subject.call
        expect(json.length).to eq 2
        expect(json.map { |tab| tab[:tab_header] }).to match_array ['GEF Core Indicators', 'Core Areas']
        expect(json[0][:categories].length).to eq indicator_scores.count
        expect(json[1][:categories].length).to eq focal_areas.count
      end
    end
  end
end
