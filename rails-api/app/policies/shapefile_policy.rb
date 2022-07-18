class ShapefilePolicy < ApplicationPolicy
  def show?
    record.gef_project&.task_manager == user
  end

  def update?
    record.gef_project&.task_manager == user
  end

  def destroy?
    record.gef_project&.task_manager == user
  end

  def create?
    record.gef_project&.task_manager == user
  end
end
