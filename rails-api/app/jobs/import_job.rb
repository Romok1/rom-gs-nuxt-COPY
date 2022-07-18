class ImportJob < ApplicationJob
  queue_as :import

  def perform
    if SyncStatus.new.should_sync_again?
      gef_project_import = GEFProjectImport.create(status: :pending)
      Importers::Sharepoint.new(gef_project_import).call

      indicator_import = IndicatorImport.create(status: :pending)
      Importers::Sharepoint.new(indicator_import).call
    end
  end
end
