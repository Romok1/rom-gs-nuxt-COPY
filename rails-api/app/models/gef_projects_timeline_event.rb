class GEFProjectsTimelineEvent < ApplicationRecord
  belongs_to :gef_project
  belongs_to :timeline_event

  validates_presence_of :date
end