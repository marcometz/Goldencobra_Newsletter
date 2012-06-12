source "http://rubygems.org"

gemspec

# jquery-rails is used by the dummy application
gem 'activeadmin', :git => "git://github.com/ikusei/active_admin.git", :require => "activeadmin"
gem 'goldencobra', :git => "git://github.com/ikusei/Goldencobra.git"
gem 'goldencobra_email_templates', :git => "git://github.com/ikusei/goldencobra_email_templates.git"
gem 'compass-rails'
gem 'coffee-rails'

gem "rspec-rails", :group => [:test, :development] # rspec in dev so the rake tasks run properly

group :development do
  gem 'thin'
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
  gem 'guard-annotate'
  gem 'pry'
  gem 'thin'
  gem 'git-pivotal'
end

group :test do
  gem 'rspec'
  gem 'mysql2'
  gem 'cucumber'
  gem 'cucumber-rails', '~> 1.3.0' 
  gem "factory_girl_rails"
  gem 'database_cleaner'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'webrat'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'guard-livereload'
  gem 'rb-fsevent', :git => 'git://github.com/ttilley/rb-fsevent.git', :branch => 'pre-compiled-gem-one-off'
  gem 'growl'
  gem 'launchy'
  gem 'email_spec'
end
