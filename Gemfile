source 'https://rubygems.org'

gem 'rails', '3.2.8'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.5'
  gem 'coffee-rails', '~> 3.2.1'

# Commenting out until 2.1 is released
#  gem 'bootstrap-sass', '~> 2.1'
# Trying out https://github.com/Aymkdn/Datepicker-for-Bootstrap instead
#  gem 'bootstrap-datepicker-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

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

gem 'devise', '~> 2.1'
gem 'omniauth-facebook'
gem 'omniauth-twitter'

group :development do
  gem 'sqlite3'
  gem 'debugger'
  
  gem 'rspec-rails'
  gem 'faker'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
  
  gem 'rspec'
  gem 'webrat'
  gem 'factory_girl_rails', '~> 4.0'
end

group :production do
  gem 'heroku'
  gem 'pg'
  gem 'thin'
end