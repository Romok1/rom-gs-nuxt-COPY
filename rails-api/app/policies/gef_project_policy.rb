class GEFProjectPolicy < ApplicationPolicy
  def index?
    user.task_manager? || user.portfolio_manager?
  end

  def show?
    record&.task_manager == user || user.portfolio_manager?
  end

  def update?
    record&.task_manager == user
  end

  def destroy?
    record&.task_manager == user
  end

  def discarded?
    return user.task_manager? if record == GEFProject

    record&.task_manager == user
  end

  class Scope < Scope
    def resolve
      if user.task_manager?
        gef_project_ids = user.gef_projects_users.where(role: Role.task_manager).pluck(:gef_project_id)
        scope.where(id: gef_project_ids)
      elsif user.portfolio_manager?
        scope.undiscarded
      else
        scope.none
      end
    end
  end
end
