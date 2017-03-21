Delayed::Worker.max_attempts = 2
Delayed::Worker.max_run_time = 5.minutes
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))

# Make test environment not use delays.
Delayed::Worker.delay_jobs = !Rails.env.test?
# Delayed::Worker.delay_jobs = !%w[ test ].include?(Rails.env)
