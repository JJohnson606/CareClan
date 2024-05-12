source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.1'
gem 'aws-sdk-s3'
gem 'chartkick'
gem 'debug'
gem 'erb_lint'
gem 'good_job', '~> 3.28'
gem 'kaminari', '~> 1.2', '>= 1.2.2'
gem 'noticed', '~> 2.2'
gem 'postmark'
gem 'postmark-rails'
gem 'pundit'
gem 'ransack'
gem 'simple_form'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.7', '>= 7.0.7'

# Update rake gem file to 13.1.0
gem 'rake', '13.1.0'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Generates uuids for security
gem 'pgcrypto', '~> 0.4.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 6.0'

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem 'cssbundling-rails'

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem 'jsbundling-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'image_processing', '~> 1.2'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  # gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end
# AppDev Gems
# ===========
gem 'acts_as_votable', '~> 0.14.0'
gem 'appdev_support'
gem 'awesome_print'
gem 'devise'
gem 'dotenv-rails'
gem 'faker'
gem 'htmlbeautifier'
gem 'http'
gem 'sqlite3', '~> 1.4'
gem 'table_print'
gem 'ui_faces'

group :development do
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'bullet'
  gem 'draft_generators'
  gem 'grade_runner'
  gem 'letter_opener', '~> 1.10'
  gem 'pry-rails'
  gem 'rails_db'
  gem 'rails-erd'
  gem 'rubocop-capybara'
  gem 'rubocop-rails'
  gem 'rubocop-rake'
  gem 'rufo'
  gem 'specs_to_readme'
  gem 'web_git'
end

group :development, :test do
  gem 'rspec-rails', '~> 6.0.0'
end

group :test do
  gem 'draft_matchers' # , "0.0.2"#path: "../../my_stuff/draft_matchers"
  # gem "draft_matchers"
  gem 'rspec-html-matchers'
  gem 'webmock'
end
