Delayed::Worker.max_attempts = 5
Delayed::Worker.max_run_time = 5.minutes
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))

# Make test environment not use delays.
Delayed::Worker.delay_jobs = !Rails.env.test?
# Delayed::Worker.delay_jobs = !%w[ test ].include?(Rails.env)

# How to remove delayed_job activerecord logs from production.log
# https://github.com/collectiveidea/delayed_job/issues/886
ActiveRecord::Base.logger.level = 1
