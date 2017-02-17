source 'https://rubygems.org'
ruby '2.3.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 5.0.0.rc1', '< 5.1'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.18', '< 0.5'
# Use Puma as the app server
# gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.x'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'nokogiri', '~> 1.6.8'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec'
  gem 'rspec-rails'
  gem 'rspec-collection_matchers'
  gem 'better_errors'
  gem 'factory_girl_rails'
  gem 'guard-rspec', require: false
  gem 'faker'
  gem 'pry'
  gem 'database_cleaner'
  gem 'rubocop', '~> 0.35.0', require: false
  gem 'rubocop-checkstyle_formatter', require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'brakeman'
end

group :test do
  gem 'simplecov', require: false
  gem 'simplecov-rcov', require: false
  gem 'shoulda-matchers'
end

group :staging, :production do
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano-sidekiq'
  gem 'capistrano-passenger'
  gem 'passenger', '>= 5.0.25', require: 'phusion_passenger/rack_handler'
  gem 'capistrano3-unicorn'
  gem 'unicorn'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'dotenv-rails'
gem 'config'
gem 'devise', git: 'https://github.com/plataformatec/devise.git'
gem 'unicorn-worker-killer'
gem 'kaminari'
gem 'bootstrap-kaminari-views'
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'redis-rack', github: 'redis-store/redis-rack', branch: 'master'
gem 'redis-actionpack', github: 'redis-store/redis-actionpack', branch: 'master'
gem 'redis-rails', github: 'redis-store/redis-rails', branch: 'master'
gem 'redis-namespace'
gem 'sinatra', github: 'sinatra'
gem 'figaro'
gem 'slim'
gem 'cancancan'
gem 'paranoia', github: 'rubysherpas/paranoia', branch: 'rails4'
gem 'ransack'
gem 'state_machines-activerecord'
gem 'carrierwave'
gem 'fog'
gem 'aws-sdk', '~> 1.66.0'
gem 'capistrano-faster-assets'
