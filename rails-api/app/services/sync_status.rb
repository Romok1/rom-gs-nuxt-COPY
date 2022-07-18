# frozen_string_literal: true

class SyncStatus
  def should_sync_again?
    should_sync_import_type?(GEFProjectImport) && should_sync_import_type?(IndicatorImport)
  end

  private

  def should_sync_import_type?(klass)
    klass.last_sync.nil? ||
      klass.last_sync&.status.in?(%w[completed failed]) ||
      klass.last_sync.updated_at < 10.minutes.ago
  end
end
