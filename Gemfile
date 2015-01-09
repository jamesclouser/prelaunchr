source 'https://rubygems.org'

ruby '2.2.0'

gem 'rails', '3.2.16'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'

gem 'activeadmin'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.5'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'sass', '3.2.13'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.2.3'
end

group :development do
  gem 'pry'
end

gem 'delayed_job_active_record'
gem 'unicorn'


group :staging, :production do
  gem 'newrelic_rpm', '>= 3.6.7'
  gem 'rails_12factor'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
