FactoryBot.define do
  factory(:role) do
    name {}

    factory(:task_manager_role) do
      name { 'Task Manager' }
    end

    factory(:portfolio_manager_role) do
      name { 'Portfolio Manager' }
    end
  end
end
