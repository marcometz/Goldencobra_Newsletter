source "http://rubygems.org"

gemspec

# jquery-rails is used by the dummy application
gem 'activeadmin', :git => "git://github.com/ikusei/active_admin.git", :require => "activeadmin"
gem 'goldencobra', :git => "ssh://git@git.ikusei.de:7999/GC/basis-modul.git"
gem 'goldencobra_email_templates', :git => "ssh://git@git.ikusei.de:7999/GC/goldencobra-email-templates.git"
gem 'compass-rails'
gem 'coffee-rails'
gem 'capistrano', '2.14.1'
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
  gem 'cucumber-rails'
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
