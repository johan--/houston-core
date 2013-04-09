source 'http://rubygems.org'

gem 'rails', '3.2.13'
gem 'activerecord-postgres-hstore' # remove when Rails 4.0

# Database
gem 'pg'

# Twitter Bootstrap
gem 'twitter-bootstrap-rails'

# Font Awesome
gem 'font-awesome-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'therubyracer' # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'less-rails' # For Twitter Bootstrap
  gem 'uglifier', '>= 1.0.3'
  
  gem 'turbo-sprockets-rails3', '>= 0.3.6'
end

# Sass is required in production (see layouts/email.html.erb)
gem 'sass-rails',   '~> 3.2.3'

# Javascript
gem 'jquery-rails'
gem 'sugar-rails'
gem 'backbone-rails'
gem 'handlebars_assets', '0.8.2'

# Helpers
gem 'addressable', :require => 'addressable/uri'
gem 'redcarpet'
gem 'bundler' # used to parse Gemfiles
gem 'cancan'
gem 'childprocess'
gem 'default_value_for'
gem 'devise',           '~> 2.2.3'
gem 'devise_invitable', '~> 1.1.6'
gem 'devise_ldap_authenticatable', :git => 'https://github.com/houstonmc/devise_ldap_authenticatable.git'
gem 'faraday'
gem 'foreman'
gem 'foreman-export-initscript', :git => 'git://github.com/LewisJA/foreman-export-initscript.git'
gem 'gemoji'
gem 'googlecharts'
gem 'hpricot'
gem 'newrelic_rpm'
gem 'nokogiri'
gem 'premailer' # for inlining CSS in HTML emails
gem 'remotable', '>= 0.2.2', :git => 'git://github.com/boblail/remotable.git'
gem 'resque'
gem 'rugged', '0.17.0.b7'
gem 'yajl-ruby', :require => 'yajl/json_gem'
gem 'whenever' # a DSL for writing CRON jobs



# Modules
#
# Here modules are dynamically included in the Gemfile
#
require './lib/configuration.rb' # Loads Houston's configuration
Houston.config.modules.each do |mod|
  gem *mod.gemspec
end



# Exception notification
# gem 'airbrake_user_attributes'
gem 'airbrake'

group :development do
  gem 'thin'
  gem 'letter_opener'
  gem 'rack-mini-profiler'
  
  # Better error messages
  gem 'better_errors'
  gem 'meta_request'
end

group :development, :test do
  gem 'minitest'
  gem 'turn', :require => false # for prettier tests
  gem 'rr'
  
  # For Jenkins
  gem 'simplecov', :require => false
  gem 'simplecov-json', :require => false, :git => 'git://github.com/houstonmc/simplecov-json.git'
  gem 'ci_reporter', :require => false
  
  gem 'pry' # for debugging
end
