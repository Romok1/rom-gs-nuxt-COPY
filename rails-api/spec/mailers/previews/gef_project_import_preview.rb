# Preview all emails at http://localhost:3000/rails/mailers/gef_project_import
class GEFProjectImportPreview < ActionMailer::Preview
  def import_errors
    gef_project_import = GEFProjectImport.create
    gef_project_import.gef_project_import_errors.create([
      { row_number: 3, message: 'An error message for row 3' },
      { row_number: 4, message: 'An error message for row 4' }
    ])
    ImportErrorMailer.with(import: gef_project_import).import_errors
  end
end
