shared_context 'user_setup' do
  let!(:task_manager_role) { FactoryBot.create(:task_manager_role) }
  let(:task_manager) { FactoryBot.create(:user, role: task_manager_role) }
  let!(:portfolio_manager_role) { FactoryBot.create(:portfolio_manager_role) }
  let(:portfolio_manager) { FactoryBot.create(:user, role: portfolio_manager_role) }
end
