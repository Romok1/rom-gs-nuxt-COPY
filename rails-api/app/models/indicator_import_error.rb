class IndicatorImportError < ApplicationRecord
  belongs_to :indicator_import
  belongs_to :gef_project, optional: true
end
