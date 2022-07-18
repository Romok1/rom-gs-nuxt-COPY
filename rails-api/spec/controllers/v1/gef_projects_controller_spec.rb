require 'rails_helper'

RSpec.describe V1::GEFProjectsController, type: :controller do
  include_context 'user_setup'

  let!(:gef_projects_for_a_task_manager) do
    create_list(:gef_project_with_user_with_role, 5, user: task_manager, role: task_manager_role)
  end
  let!(:discarded_gef_projects_for_a_task_manager) do
    create_list(:gef_project_with_user_with_role, 3, user: task_manager, role: task_manager_role,
      discarded_at: DateTime.now)
  end
  let!(:another_gef_project) { create(:gef_project) }
  let!(:another_discarded_gef_project) { create(:gef_project, discarded_at: DateTime.now) }

  describe 'signed in' do
    context 'portfolio_manager' do
      before do
        sign_in portfolio_manager
      end

      context 'GET #index' do
        it 'returns a list of undiscarded GEF Projects' do
          get :index, format: :json
          expect(response).to have_http_status(:ok)
          json_data = JSON.parse(response.body)
          expect(json_data.class).to eq Array
          expect(json_data.length).to eq GEFProject.undiscarded.count
        end

        it 'does not return a list of discarded GEF Projects' do
          get :index, params: { discarded: true }, format: :json
          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'GET #show' do
        it 'returns a GEF Project' do
          get :show, params: { id: another_gef_project.gef_id }, format: :json
          expect(response).to have_http_status(:ok)
          json_data = JSON.parse(response.body)
          expect(json_data.class).to eq Hash
        end
      end

      context 'DELETE #destroy' do
        it 'does not discard a project' do
          delete :destroy, params: { id: another_gef_project.gef_id }, format: :json
          expect(response).to have_http_status(:forbidden)
          expect(another_gef_project.reload.discarded?).to eq false
        end
      end

      context 'PUT #update' do
        it 'does not discard a project' do
          gef_projects_for_a_task_manager.first.discard!
          put :update, params: { id: gef_projects_for_a_task_manager.first.gef_id }, format: :json
          expect(response).to have_http_status(:forbidden)
          expect(gef_projects_for_a_task_manager.first.reload.discarded?).to eq true
        end
      end
    end

    context 'task_manager' do
      before do
        sign_in task_manager
      end

      context 'GET #index' do
        it 'returns a list of GEF Projects belonging to task manager' do
          get :index, format: :json
          expect(response).to have_http_status(:ok)
          json_data = JSON.parse(response.body)
          expect(json_data.class).to eq Array
          expect(json_data.length).to eq gef_projects_for_a_task_manager.count
        end

        it 'returns a list of discarded GEF Projects' do
          get :index, params: { discarded: true }, format: :json
          expect(response).to have_http_status(:ok)
          json_data = JSON.parse(response.body)
          expect(json_data.class).to eq Array
          expect(json_data.length).to eq discarded_gef_projects_for_a_task_manager.count
        end
      end

      context 'GET #show' do
        context 'when task manager of the project' do
          it 'returns a GEF Project' do
            get :show, params: { id: gef_projects_for_a_task_manager.first.gef_id }, format: :json
            expect(response).to have_http_status(:ok)
            json_data = JSON.parse(response.body)
            expect(json_data.class).to eq Hash
          end
        end

        context 'when not task manager of the project' do
          it 'does not return a GEF Project' do
            get :show, params: { id: another_gef_project.gef_id }, format: :json
            expect(response).to have_http_status(:forbidden)
          end
        end
      end

      context 'DELETE #destroy' do
        context 'when not task_manager of project' do
          it 'does not discard a project' do
            delete :destroy, params: { id: another_gef_project.gef_id }, format: :json
            expect(response).to have_http_status(:forbidden)
            expect(another_gef_project.reload.discarded?).to eq false
          end
        end

        context 'when task_manager of project' do
          it 'discards the project' do
            delete :destroy, params: { id: gef_projects_for_a_task_manager.first.gef_id }, format: :json
            expect(response).to have_http_status(:ok)
            expect(gef_projects_for_a_task_manager.first.reload.discarded?).to eq true
          end
        end
      end

      context 'PUT #update' do
        context 'when not task_manager of project' do
          it 'does not discard a project' do
            another_gef_project.discard!
            put :update, params: { id: another_gef_project.gef_id }, format: :json
            expect(response).to have_http_status(:forbidden)
            expect(another_gef_project.reload.discarded?).to eq true
          end
        end

        context 'when task_manager of project' do
          it 'discards the project' do
            gef_projects_for_a_task_manager.first.discard!
            put :update, params: { id: gef_projects_for_a_task_manager.first.gef_id }, format: :json
            expect(response).to have_http_status(:ok)
            expect(gef_projects_for_a_task_manager.first.reload.discarded?).to eq false
          end
        end
      end
    end
  end

  describe 'not signed in' do
    context 'GET #index' do
      it 'returns unauthorized for undiscarded projects' do
        get :index, format: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns unauthorized for discarded projects' do
        get :index, params: { discarded: true }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'GET #show' do
      it 'returns unauthorized' do
        get :show, params: { id: another_gef_project.id }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'DELETE #destroy' do
      it 'returns unauthorized' do
        delete :destroy, params: { id: another_gef_project.id }, format: :json
        expect(response).to have_http_status(:unauthorized)
        expect(another_gef_project.reload.discarded?).to eq false
      end
    end

    context 'PUT #update' do
      it 'returns unauthorized' do
        another_gef_project.discard!
        put :update, params: { id: another_gef_project.id }, format: :json
        expect(response).to have_http_status(:unauthorized)
        expect(another_gef_project.reload.discarded?).to eq true
      end
    end
  end
end
