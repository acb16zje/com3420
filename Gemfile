source "https://rubygems.org"
ruby '2.3.1'
gem 'rails', '5.1.4'
gem 'responders'
gem 'activerecord-session_store', git: 'https://github.com/epigenesys/activerecord-session_store.git', branch: 'rails-5-generator'
gem 'thin'

gem 'sqlite3', group: [:development, :test]
gem 'pg'

gem 'airbrake', git: 'https://github.com/epigenesys/airbrake.git', branch: 'airbrake-v4'

gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'

gem 'jquery-rails'
gem 'select2-rails'
gem 'bootstrap-sass'
gem 'epi_js'
gem 'gon'

gem 'simple_form'
gem 'ransack', '~> 1.8.0'

gem 'polyamorous', '~> 1.3.1'

gem 'devise'
gem 'devise_ldap_authenticatable'
gem 'devise_cas_authenticatable'
gem 'cancancan'
gem "epi_cas", git: "git@git.shefcompsci.org.uk:gems/epi_cas.git"

gem 'whenever'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'delayed-plugins-airbrake'
gem 'daemons'

gem 'carrierwave'
gem 'rubyXL'

gem 'multi_json', '~> 1.13', '>= 1.13.1'
gem 'jbuilder', '~> 2.7'

gem 'premailer-rails'
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
end

group :test do
  gem 'capybara-select2', git: 'https://github.com/goodwill/capybara-select2.git'
  gem 'factory_bot_rails'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'poltergeist'
  gem 'rspec-instafail', require: false

  gem 'launchy'
  gem 'simplecov'
end
