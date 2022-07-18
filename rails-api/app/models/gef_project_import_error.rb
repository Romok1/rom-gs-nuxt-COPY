class GEFProjectImportError < ApplicationRecord
  belongs_to :gef_project_import
  belongs_to :gef_project, optional: true
end
