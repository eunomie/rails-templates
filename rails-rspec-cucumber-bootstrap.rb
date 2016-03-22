# -d postgresql --skip-turbolinks -T -m rails-rspec-cucumber-bootstrap.rb

# TODO:
# - rubocop
# - coverage

file '.ruby-version', <<RUBY
ruby-2.3.0
RUBY

gem_group :development, :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'factory_girl_rails'
  gem 'faker'
end

gem_group :test do
  gem 'shoulda-matchers'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'guard-cucumber', require: false
end

gem 'turbolinks', '~> 5.0.0.beta'
gem 'haml', '~> 4.0.7'
gem 'haml-rails', '~> 0.9'
gem 'nprogress-rails'
gem "autoprefixer-rails"
gem 'bootstrap', '~> 4.0.0.alpha3'

append_to_file 'Gemfile', <<TETHER

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
end
TETHER

gem_group :production do
  gem 'rails_12factor'
end

file '.rspec', <<-RSPEC
--color
--require spec_helper
RSPEC

file 'db/schema.rb', <<-DB
# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 0) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

end
DB

append_to_file 'Gemfile', <<RUBY

ruby "2.3.0"
RUBY

remove_file 'app/assets/stylesheets/application.css'
remove_file 'app/assets/javascripts/application.js'

file 'app/assets/stylesheets/alert.scss', <<CSS
.alert-alert {
  @extend .alert-warning;
}

.alert-notice {
  @extend .alert-info;
}
CSS

file 'app/assets/stylesheets/application.scss', <<CSS
@import "bootstrap-flex";

@import 'nprogress';
@import 'nprogress-bootstrap';

@import 'alerts';
CSS

file 'app/assets/javascripts/application.js', <<JS
//= require jquery
//= require tether
//= require bootstrap
//= require jquery_ujs
//= require turbolinks
//= require nprogress
//= require nprogress-turbolinks
//= require_tree .
JS

file 'app/assets/javascripts/nprogress_turbolinks_5.js', <<JS
jQuery(function() {
  jQuery(document).on('turbolinks:visit', function() { NProgress.start();  });
  jQuery(document).on('turbolinks:request-end', function() { NProgress.set(0.7); });
  jQuery(document).on('turbolinks:render', function() { NProgress.done();   });
});
JS

rakefile("test.rake") do
  <<-TASK
    if Rails.env.test? || Rails.env.development?
      require 'rspec/core/rake_task'
      require 'cucumber/rake/task'

      task test: [:spec, :cucumber]
    end
  TASK
end

after_bundle do
  run 'spring stop'
  run 'spring binstub --all'
  generate 'rspec:install'
  generate 'cucumber:install'

  run 'guard init rspec'
  run 'guard init cucumber'

  append_to_file 'spec/rails_helper.rb', <<SHOULDA
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec

    with.library :rails
  end
end
SHOULDA

  rake 'db:create' if yes? "Do you want to create the database? [yn]"

  git :init

  if yes? "Do you want to configure git user? [yn]"
    user = ask("Name:")
    email = ask("Email:")
    git config: "user.name \"#{user}\""
    git config: "user.email \"#{email}\""
  end

  git commit: '--allow-empty -m "Init repo"'

  git checkout: '-b init'
  git add: '.ruby-version'
  git commit: '-m "Ruby"'

  git add: '.'
  git commit: '-a -m "rails-rspec-cucumber init"'

  git checkout: 'master'
  git merge: '--no-ff -m "Initialize Rails boilerplate" init'
  git branch: '-d init'
end
