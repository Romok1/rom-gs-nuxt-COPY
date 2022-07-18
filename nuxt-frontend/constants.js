export const STATUS_TYPES = {
  success: 'success',
  warning: 'warning',
  info: 'info',
  pending: 'pending',
  error: 'error',
  unknown: 'unknown'
}

export const GEF_PROJECT_CURRENT_STATUS_TYPE_MAPPINGS = {
  completed: STATUS_TYPES.success,
  'under implementation': STATUS_TYPES.warning,
  'technically completed': STATUS_TYPES.success,
  'ceo endorsed': STATUS_TYPES.success,
  'pif approved': STATUS_TYPES.success,
  closed: STATUS_TYPES.error,
  'pfd approved': STATUS_TYPES.pending,
  'ppg design': STATUS_TYPES.info,
  'child project concept approved': STATUS_TYPES.info,
  'pif under-review': STATUS_TYPES.info,
  'pif submitted': STATUS_TYPES.warning
}

export const USER_ROLES = {
  taskManager: 'Task Manager',
  portfolioManager: 'Portfolio Manager'
}

// export const LAST_SYNC_CHANNEL_CLASSNAME = 'GEFProjects::LastSyncChannel'
export const LAST_SYNC_ICON_ACTIVE_STATES = [
  'pending',
  'processing'
]

// export const IMPORT_ERROR_COUNT_CHANNEL_CLASS = 'GEFProjects::ImportErrorPresenceChannel'
// export const IMPORT_ERROR_COUNT_CHANNEL = 'gef_projects:import_presence_count'

export const RELOAD_GEF_PROJECTS_PAGE_EVENT_NAME = 'pages:gef-projects:reload'

/**
 * These values seem the reverse of what they should be and that is because
 * the gef_projects table in the backend contains the direct English values
 * as the statuses. For i18n purposes, we will use those as the keys to get
 * the translations from our locales - even if the English ones are the same.
 */
export const GEF_PROJECT_VALID_STATUSES = {
  Completed: 'completed',
  'N/A': 'na',
  'Not Completed': 'notCompleted',
  Ongoing: 'ongoing',
  'Under Implementation': 'underImplementation'
}

export const GEF_PROJECT_PILL_STATUS_MAPPING_DEFAULT = 'unknown'

export const GEF_PROJECT_PILL_STATUS_MAPPING = {
  Completed: 'success',
  'N/A': GEF_PROJECT_PILL_STATUS_MAPPING_DEFAULT,
  'Not Completed': 'pending',
  Ongoing: 'warning',
  'Under Implementation': 'info'
}
