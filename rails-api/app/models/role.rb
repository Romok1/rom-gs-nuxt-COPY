# frozen_string_literal: true

class Role < ApplicationRecord
  has_many :gef_projects_users
  has_many :users

  validates_uniqueness_of :name

  NAMES = [
    'Task Manager',
    'Portfolio Manager',
    'FMO',
    'PA Focal Point',
    'FA Focal Point'
  ].freeze

  NAMES.each do |role_name|
    role_snakecase = role_name.downcase.gsub(' ', '_')

    define_singleton_method(role_snakecase) do
      find_by_name(role_name)
    end
  end
end
