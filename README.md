Rails templates
===============

A simple collection of templates for [Rails](http://rubyonrails.org).

rails-rspec-cucumber-bootstrap
------------------------------

Initialize a rails app with:

- [rspec](https://github.com/rspec/rspec) (with [guard](https://github.com/guard/guard-rspec))
- [cucumber](https://github.com/cucumber/cucumber) (with [guard](https://github.com/guard/guard-cucumber))
- [faker](https://github.com/stympy/faker)
- [factory girl](https://github.com/thoughtbot/factory_girl)
- [shoulda matchers](https://github.com/thoughtbot/shoulda-matchers)
- [boostrap 4](https://github.com/twbs/bootstrap-rubygem)
- [turbolinks 5](https://github.com/turbolinks/turbolinks)
- [nprogress](https://github.com/caarlos0/nprogress-rails)
- [haml](https://github.com/haml/haml)
- scss syntax
- git repository initialized, with a first empty commit

The template asks you:

- to create the database (run `rake db:create`)
- to configure user and email for git

### Usage

Execute `rails` command without tests and turbolinks. By example:

```
rails new testapp -d postgresql --skip-turbolinks -T \
  -m https://raw.githubusercontent.com/eunomie/rails-templates/master/rails-rspec-cucumber-bootstrap.rb
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
