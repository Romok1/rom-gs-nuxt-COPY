# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, '/log/cron_log.log'

every 1.hour do
  runner 'ImportJob.perform_later'
end

every 1.day, at: '1:00 am' do
  rake 'active_storage:purge_unattached'
end
# Learn more: http://github.com/javan/whenever
