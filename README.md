Rails templates
===============

A simple collection of templates for [Rails](http://rubyonrails.org).

Initialize a rails app with:

- [rspec](https://github.com/rspec/rspec) (with [guard](https://github.com/guard/guard-rspec))
- [cucumber](https://github.com/cucumber/cucumber) (with [guard](https://github.com/guard/guard-cucumber))
- [rubocop](https://github.com/bbatsov/rubocop) (_optional_)
- [simplecov](https://github.com/colszowka/simplecov) (_optional_)
- [faker](https://github.com/stympy/faker)
- [factory girl](https://github.com/thoughtbot/factory_girl)
- [shoulda matchers](https://github.com/thoughtbot/shoulda-matchers)
- [boostrap 4](https://github.com/twbs/bootstrap-rubygem)
- [turbolinks 5](https://github.com/turbolinks/turbolinks)
- [nprogress](https://github.com/caarlos0/nprogress-rails)
- [haml](https://github.com/haml/haml)
- an authentication system ([devise](https://github.com/plataformatec/devise) or [clearance](https://github.com/thoughtbot/clearance)) (_optional_)
- [administrate](https://github.com/thoughtbot/administrate) (_optional_)
- scss syntax
- git repository initialized, with a first empty commit

The template asks if you want:

- to configure user and email for git
- to configure ruby version (`.ruby-version`)
- to install rubocop
- to install simplecov
- to create the database (run `rake db:create`)
- to add an authentication system (devise, clearance)
- to install administrate

### Usage

Execute `rails` command without tests and turbolinks. By example:

```
rails new testapp -d postgresql --skip-turbolinks -T \
  -m https://raw.githubusercontent.com/eunomie/rails-templates/master/template.rb
```

Contributing
------------

1. [Fork it](https://github.com/eunomie/rails-templates/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new _Pull Request_

LICENSE
-------

Please see [LICENSE](https://github.com/eunomie/rails-template/blob/master/LICENSE).

AUTHOR
------

Yves Brissaud, [@\_crev_](https://twitter.com/_crev_), [@eunomie](https://github.com/eunomie)
