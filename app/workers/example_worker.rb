# app/workers/example_worker.rb
class ExampleWorker
  include Sidekiq::Worker

  def perform(arg1, arg2)
    # Perform some work here
    puts "Performing job with arguments: #{arg1}, #{arg2}"
  end
end
