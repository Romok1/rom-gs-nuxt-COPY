class GEFProjectsUser < ApplicationRecord
  belongs_to :user
  belongs_to :gef_project
  belongs_to :role
end
