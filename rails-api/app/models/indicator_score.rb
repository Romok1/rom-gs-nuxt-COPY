class IndicatorScore < ApplicationRecord

  enum assessment_type: %i[pir_year baseline expected_results]

  belongs_to :gef_project
  belongs_to :indicator

  validates_presence_of :value, :assessment_type
end
