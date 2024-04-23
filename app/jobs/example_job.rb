# app/jobs/example_job.rb
class ExampleJob
    include Sidekiq::Worker
  
    def perform(*args)
      puts "Job is running with arguments: #{args.inspect}"
    end
  end
  