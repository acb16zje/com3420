source "https://rubygems.org"
ruby '2.3.1'
gem 'rails', '5.1.4'
gem 'responders'
gem 'activerecord-session_store', git: 'https://github.com/epigenesys/activerecord-session_store.git', branch: 'rails-5-generator'
gem 'thin'

gem 'sqlite3', group: [:development, :test]
gem 'pg', '~> 0.21'

gem 'airbrake', git: 'https://github.com/epigenesys/airbrake.git', branch: 'airbrake-v4'

gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'

gem 'jquery-rails'
gem 'epi_js'

gem 'simple_form'
gem 'draper'
gem 'ransack', '~> 1.8.0'

gem 'polyamorous', '~> 1.3.1'

gem 'will_paginate', '~> 3.1.5'

gem 'devise'
gem 'devise_ldap_authenticatable'
gem 'devise_cas_authenticatable'
gem 'cancancan'

gem 'whenever'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'delayed-plugins-airbrake'
gem 'daemons'

group :development, :test do
  gem 'rspec-rails'
  gem 'byebug'
end

group :development do
  gem 'listen'
  gem 'web-console'
  gem 'spring'

  gem 'capistrano', '~> 3.4'
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-passenger', require: false
  gem 'epi_deploy', git: 'https://github.com/epigenesys/epi_deploy.git'

  gem 'eventmachine'
  gem 'letter_opener'
  gem 'annotate'
  gem 'rails_real_favicon'
end

group :test do
  gem 'capybara-select2', git: 'https://github.com/goodwill/capybara-select2.git'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'poltergeist'
  gem 'rspec-instafail', require: false


  gem 'launchy'
  gem 'simplecov'
end
