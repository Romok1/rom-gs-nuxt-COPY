# frozen_string_literal: true

class GEFProject < ApplicationRecord
  include Discard::Model

  has_and_belongs_to_many :implementing_agencies
  has_and_belongs_to_many :georegions
  has_and_belongs_to_many :focal_areas

  has_many :gef_projects_users, dependent: :destroy
  has_many :users, through: :gef_projects_users

  has_many :indicator_scores, dependent: :destroy
  has_many :indicators, -> { distinct }, through: :indicator_scores

  has_many :gef_project_import_errors, dependent: :destroy
  has_many :indicator_import_errors, dependent: :destroy

  has_many :gef_projects_timeline_events, -> { order('gef_projects_timeline_events.date ASC') }, dependent: :destroy
  has_many :timeline_events, through: :gef_projects_timeline_events

  has_one :shapefile, dependent: :destroy
  has_many :shapefile_import_errors, through: :shapefile, dependent: :destroy

  accepts_nested_attributes_for :gef_projects_users, allow_destroy: true
  accepts_nested_attributes_for :gef_projects_timeline_events, allow_destroy: true
  accepts_nested_attributes_for :indicator_scores, allow_destroy: true

  validates_presence_of :gef_id, :title
  validates_uniqueness_of :gef_id

  # dynamically add getter and setter methods for each of the roles a user can have for a GEFProject:
  # task_manager, fmo, pa_focal_point, fa_focal_point, portfolio_manager
  # e.g. gef_project.task_manager
  # e.g. gef_project.task_manager=(user)
  Role::NAMES.each do |role|
    define_method(role.downcase.gsub(' ', '_')) do
      user_with_role(role)
    end

    define_method("#{role.downcase.gsub(' ', '_')}=") do |argument|
      set_user_with_role(role, argument)
    end
  end

  def timeline
    TimelineEvent.left_outer_joins(:gef_projects_timeline_events)
      .where({ gef_projects_timeline_events: { gef_project_id: [nil, id] } })
      .order('timeline_events.order ASC')
      .pluck(:name, :date).map do |name, date|
      {
        name:,
        date:
      }
    end
  end

  def import_errors?
    gef_project_import_errors.any? || indicator_import_errors.any? || shapefile_import_errors.any?
  end

  alias has_import_errors import_errors?

  private

  def user_with_role(role)
    gef_project_users_with_role = gef_projects_users.joins(:role).where(roles: { name: role })
    gef_project_users_with_role.any? ? gef_project_users_with_role.first.user : nil
  end

  def set_user_with_role(role, user)
    role_id = Role.find_by_name(role).id
    gef_project_user = GEFProjectsUser.find_or_initialize_by(role_id:, gef_project_id: id)
    gef_project_user.user = user
    gef_project_user.save!
  end
end
