# -d postgresql --skip-turbolinks -T -m template.rb

options = {
           git_config: false,
           git: { user: '', email: '' },
           init_db: false,
           ruby_version: RUBY_VERSION,
           rubocop: false,
           simplecov: false,
           auth_config: false,
           auth: {
                  available: [:devise, :clearance],
                  wanted: :clearance,
                  clearance: { generate_views: false }
                 },
           administrate: false
          }

puts ""
puts "    Rails configuration"
puts "    ==================="
puts ""

puts "    Git"
puts "    ---"
puts ""

options[:git_config] = yes? "Do you want to configure git user? [yn]"
if options[:git_config]
  options[:git][:user] = ask "Name:"
  options[:git][:email] = ask "Email:"
end

puts ""
puts "    Ruby"
puts "    ----"
puts ""

if yes? "Do you want to configure the ruby version? Current is '#{options[:ruby_version]}' [yn]"
  options[:ruby_version] = ask "Ruby version:"
end

options[:rubocop] = yes? "Do you want to install rubocop? [yn]"

options[:simplecov] = yes? "Do you want to enable simplecov? [yn]"

puts ""
puts "    Rails"
puts "    -----"
puts ""

options[:init_db] = yes? "Do you want to create the database? [yn]"
options[:auth_config] = yes? "Do you want to add an authentication? [yn]"
if options[:auth_config]
  auth_opts = options[:auth][:available].map { |opt| opt.to_s }.join('/')
  loop do
    wanted = ask "Which authentication system do you want? [#{auth_opts}]"
    opt_ok = options[:auth][:available].include? wanted.to_sym
    if opt_ok
      options[:auth][:wanted] = wanted.to_sym
      break
    end
  end
  if options[:auth][:wanted] == :clearance
    options[:auth][:clearance][:generate_views] = yes? "Do you want to generate views? [yn]"
  end
end
options[:administrate] = yes? "Do you want to install administrate? [yn]"

puts ""

file '.ruby-version', <<RUBY
ruby-#{options[:ruby_version]}
RUBY

gem_group :development, :test do
  gem 'rspec-rails', '~> 3.4'
  gem 'factory_girl_rails'
  gem 'faker'
  if options[:rubocop]
    gem 'rubocop', require: false
  end
end

gem_group :test do
  gem 'shoulda-matchers'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'guard-cucumber', require: false
  if options[:simplecov]
    gem 'simplecov', :require => false
  end
end

gem 'turbolinks', '~> 5.0.0.beta'
gem 'haml', '~> 4.0.7'
gem 'haml-rails', '~> 0.9'
gem 'nprogress-rails'
gem "autoprefixer-rails"
gem 'bootstrap', '~> 4.0.0.alpha'
gem options[:auth][:wanted].to_s if options[:auth_config]
gem "administrate", "~> 0.2" if options[:administrate]

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

ruby "#{options[:ruby_version]}"
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

@import 'alert';
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

file '.rubocop.yml', <<RUBOCOP
Rails:
  Enabled: true
RUBOCOP

after_bundle do
  git :init

  if options[:git_config]
    git config: "user.name \"#{options[:git][:user]}\""
    git config: "user.email \"#{options[:git][:email]}\""
  end

  git commit: '--allow-empty -m "Init repo"'

  git checkout: '-b init'
  git add: '.ruby-version'
  git commit: '-m "Ruby"'

  git add: '.'
  git commit: '-a -m "Rails init with gemfile"'

  run 'spring stop'
  run 'spring binstub --all'

  generate 'rspec:install'
  run 'guard init rspec'
  append_to_file 'spec/rails_helper.rb', <<SHOULDA
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec

    with.library :rails
  end
end
SHOULDA

  git add: '.'
  git commit: '-a -m "Rspec with guard and shoulda matchers"'

  generate 'cucumber:install'
  run 'guard init cucumber'

  insert_into_file 'features/support/env.rb', <<CUCUMBER, after: "require 'cucumber/rails'\n"
require 'faker'

World(FactoryGirl::Syntax::Methods)
CUCUMBER

  git add: '.'
  git commit: '-a -m "Cucumber with guard"'

  if options[:simplecov]
    insert_into_file 'spec/spec_helper.rb', <<SIMPLECOV, after: "# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration\n"
require 'simplecov'
SimpleCov.start 'rails'
SIMPLECOV

    insert_into_file 'features/support/env.rb', <<SIMPLECOV, after: "require 'cucumber/rails'\n"
require 'simplecov'
SimpleCov.start 'rails'
SIMPLECOV

    append_to_file '.gitignore', 'coverage'

    git add: '.'
    git commit: '-a -m "Simplecov"'
  end

  rake 'db:create' if options[:init_db]

  if options[:auth_config]
    auth = options[:auth][:wanted].to_s + ':'
    generate(auth + 'install')

    git add: '.'
    git commit: "-a -m \"Authentication with #{options[:auth][:wanted].to_s}\""

    if options[:auth][:wanted] == :clearance
      if options[:auth][:clearance][:generate_views]
        remove_file 'app/views/layouts/application.html.erb'
        generate(auth + 'views')

        git add: '.'
        git commit: '-a -m "Generate auth views"'
      end
    end
  end

  if options[:administrate]
    generate 'administrate:install'
    git add: '.'
    git commit: '-a -m "Install administrate"'
  end

  if options[:init_db]
    rake 'db:migrate'
    git add: '.'
    git commit: '-a -m "Migrate"'
  end

  rake 'haml:erb2haml'
  git add: '.'
  git commit: '-a -m "Convert views to haml"'

  git checkout: 'master'
  git merge: '--no-ff -m "Initialize Rails boilerplate" init'
  git branch: '-d init'
end
