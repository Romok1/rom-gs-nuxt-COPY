module Mappers
  class TimelineEvent
    def initialize(gef_project, date_type, date)
      @gef_project = gef_project
      @date_type = date_type
      @date = date
    end

    def call
      date = @date.is_a?(Date) ? @date : nil
      if date || @date.blank?
        {
          id: saved_event&.id,
          timeline_event_id: @timeline_event.id,
          date:,
          _destroy: @date.blank?
        }
      else
        add_error(I18n.t('imports.import_errors.gef_project.date', field: @date_type, date: @date))
        nil
      end
    end

    private

    def timeline_event
      @timeline_event ||= begin
        event = ::TimelineEvent.find_by(name: ::TimelineEvent.event_name(@date_type))
        event || ::TimelineEvent.create(name: ::TimelineEvent.event_name(@date_type))
      end
    end

    def saved_event
      @gef_project.gef_projects_timeline_events.find_by(timeline_event_id: timeline_event.id)
    end

    def add_error(error)
      @gef_project.errors.add(:base, error)
    end
  end
end
