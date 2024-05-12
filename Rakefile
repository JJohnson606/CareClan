# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

if defined?(Annotate)
  Annotate.load_tasks
  Rake::Task['db:migrate'].enhance do
    Rake::Task['annotate_models'].invoke
  end
end
