# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GEFProject, type: :model do
  let(:gef_project) { create(:gef_project) }

  it 'creates a GEF Project' do
    expect(gef_project.id).not_to eq nil
  end

  describe 'associations' do
    context 'georegions' do
      let(:region) { create(:region) }
      let(:country) { create(:country) }

      it 'can have many georegions' do
        gef_project.georegions << [region, country]
        expect(gef_project.valid?).to eq true
        expect(gef_project.georegions.count).to eq 2
      end
    end

    context 'focal_areas' do
      let(:focal_areas) { create_list(:focal_area, 3) }

      it 'can have many focal areas' do
        gef_project.focal_areas << focal_areas
        expect(gef_project.valid?).to eq true
        expect(gef_project.focal_areas.count).to eq focal_areas.count
      end
    end

    context 'implementing agencies' do
      let(:implementing_agencies) { create_list(:implementing_agency, 3) }

      it 'can have many implementing agencies' do
        gef_project.implementing_agencies << implementing_agencies
        expect(gef_project.valid?).to eq true
        expect(gef_project.implementing_agencies.count).to eq implementing_agencies.count
      end
    end

    context 'users' do
      let!(:new_user) { create(:user) }

      context 'task manager' do
        let!(:task_manager_role) { create(:role, name: 'Task Manager') }

        it 'sets and gets the task manager' do
          expect { gef_project.task_manager = new_user }.to change { gef_project.task_manager }.from(nil).to(new_user)
          expect(gef_project.users.count).to eq 1
        end
      end

      context 'fmo' do
        let!(:fmo_role) { create(:role, name: 'FMO') }

        it 'sets and gets the fmo' do
          expect { gef_project.fmo = new_user }.to change { gef_project.fmo }.from(nil).to(new_user)
          expect(gef_project.users.count).to eq 1
        end
      end

      context 'fa focal point' do
        let!(:fa_focal_point_role) { create(:role, name: 'FA Focal Point') }

        it 'sets an fa focal point' do
          expect { gef_project.fa_focal_point = new_user }.to change {
                                                                gef_project.fa_focal_point
                                                              }.from(nil).to(new_user)
          expect(gef_project.users.count).to eq 1
        end
      end

      context 'pa focal point' do
        let!(:pa_focal_point_role) { create(:role, name: 'PA Focal Point') }

        it 'sets an pa focal point' do
          expect { gef_project.pa_focal_point = new_user }.to change {
                                                                gef_project.pa_focal_point
                                                              }.from(nil).to(new_user)
          expect(gef_project.users.count).to eq 1
        end
      end
    end
  end

  describe 'validations' do
    it 'fails without a gef_id' do
      gef_project.gef_id = nil
      expect(gef_project.valid?).to eq false
    end

    it 'fails without a title' do
      gef_project.title = nil
      expect(gef_project.valid?).to eq false
    end

    it 'fails if gef_id is not unique' do
      new_gef_project = build(:gef_project, gef_id: gef_project.gef_id)
      expect(new_gef_project.valid?).to eq false
    end
  end
end
