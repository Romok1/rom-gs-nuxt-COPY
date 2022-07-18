require 'rails_helper'
require 'pundit/rspec'

RSpec.describe GEFProjectPolicy, type: :policy do
  include_context 'user_setup'

  subject { described_class.new(user, gef_project) }

  let!(:undiscarded_gef_project) do
    create(:gef_project_with_user_with_role, user: task_manager, role: task_manager_role)
  end
  let!(:discarded_gef_project) do
    create(:gef_project_with_user_with_role, user: task_manager, role: task_manager_role, discarded_at: DateTime.now)
  end
  let!(:gef_project_not_linked_to_task_manager) do
    create(:gef_project)
  end

  describe 'permissions' do
    context 'for a task manager' do
      let(:user) { task_manager }
      context 'task_manager of a project' do
        let(:gef_project) { undiscarded_gef_project }
        it { is_expected.to permit_actions(%i[discarded show update destroy]) }
        it { is_expected.to forbid_actions(%i[create]) }
      end

      context 'not task manager of a project' do
        let(:gef_project) { gef_project_not_linked_to_task_manager }
        it { is_expected.to forbid_actions(%i[discarded show update destroy create]) }
      end

      context '#index' do
        let(:gef_project) { GEFProject }
        it { is_expected.to permit_action(:index) }
      end
    end

    context 'for a portfolio manager' do
      let(:user) { portfolio_manager }
      let(:gef_project) { undiscarded_gef_project }
      it { is_expected.to permit_actions(%i[show]) }
      it { is_expected.to forbid_actions(%i[discarded create update destroy]) }

      context '#index' do
        let(:gef_project) { GEFProject }
        it { is_expected.to permit_action(:index) }
      end
    end

    context 'for a user that is not a portfolio_manager or task_manager' do
      let(:user) { build(:user, role: nil) }
      let(:gef_project) { undiscarded_gef_project }
      it { is_expected.to forbid_actions(%i[discarded index show create update destroy]) }

      context '#index' do
        let(:gef_project) { GEFProject }
        it { is_expected.to forbid_action(:index) }
      end
    end
  end

  describe 'Scope' do
    let(:scope) { Pundit.policy_scope!(user, GEFProject) }

    context 'portfolio manager' do
      let(:user) { portfolio_manager }

      it 'allows only undiscarded gef_projects' do
        expect(scope.to_a).to match_array([undiscarded_gef_project, gef_project_not_linked_to_task_manager])
      end
    end

    context 'task manager' do
      let(:user) { task_manager }

      it 'allows access to all gef_projects linked to the task manager' do
        expect(scope.to_a).to match_array([undiscarded_gef_project, discarded_gef_project])
      end
    end

    context 'no role' do
      let(:user) { build(:user, role: nil) }

      it 'does not allow access to any gef_projects' do
        expect(scope.to_a).to match_array([])
      end
    end
  end
end
