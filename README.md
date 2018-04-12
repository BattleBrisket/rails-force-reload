# Rails `force_reload`

[![Gem Version](https://badge.fury.io/rb/rails-force-reload.svg)](https://badge.fury.io/rb/rails-force-reload)
[![Coverage Status](https://coveralls.io/repos/github/BattleBrisket/rails-force-reload/badge.svg?branch=master)](https://coveralls.io/github/BattleBrisket/rails-force-reload?branch=master)
[![Build Status](https://travis-ci.org/BattleBrisket/rails-force-reload.svg?branch=master)](https://travis-ci.org/BattleBrisket/rails-force-reload)

Starting in v5.0, Rails removed the `force_reload` option from ActiveRecord association readers. This gem adds that functionality back in.

```
# Collection association (has_many)

@user.posts(true)
# or @user.posts.reload

# Singular association (has_one)

@user.profile(true)
# or @user.reload.profile
# or @user.reload_profile
# See "Background" below for detail on the syntactical difference between these
```
## Installation

Gemfile
```
gem 'rails-force-reload'
```

Command line
```
gem install 'rails-force-reload'
```

## Compatibility

- Ruby 2.2.2 or greater (tested against 2.2, 2.3, 2.4, and 2.5 lines)
- Rails 5.0 or greater (tested against 5.0, 5.1 and 5.2 lines)

Tests are borrowed nearly verbatim from Rails source code.

## Background

The decision to deprecate the `@parent.association(true)` syntax was intended to simplify the API (one way to reload associations), and better honor the Principle of Least Surprise ("what's this `true` mean here?"). See the [original Groups thread](https://groups.google.com/forum/#!topic/rubyonrails-core/6ZPPg1ZmjQA/discussion) and [initial pull request](https://github.com/rails/rails/pull/20888) for further context.

We agree with the spirit of the decision, but it came with tradeoffs.

"Reload-only" syntax limits readability, specifically when conditionally reloading a given association. GitHub user [@heaven](https://github.com/heaven) offered a succinct example (in the [commit removing the functionality](https://github.com/rails/rails/commit/09cac8c67afdc4b2a1c6ae07931ddc082629b277#commitcomment-23704911), no less)

> That was pretty much useful #association(self.persisted?).
>
> It was:
>
> `record.tags(record.persisted?).map(&:name)`
>
> It becomes:
>
> `(record.persisted? ? record.tags.reload : record.tags).map(&:name)`

The first example is clearly more succinct and readily absorbed.

Reload syntax also breaks expectations when dealing with a _singular_ association (`Foo.has_one :bar`) versus a _collection_ association (`Foo.has_many :bars`).

The `reload` call comes _after_ a collection...

```
@user.posts.reload
```

but _before_ a singular

```
@user.reload.profile
```

In addition, the behavior on a singular association is not a one-for-one match with the `force_reload` syntax. Since we are reloading the parent, we also throw away any unsaved changes and existing existing caches. To compensate, a new `reload_<association>` dynamic method [was introduced](https://github.com/rails/rails/pull/27133). Our above example would be rewritten as such:

```
@user.reload_profile
```

This is the recommended way to handle singular associations, given the side effects of reloading the parent, however both methods will technically work.

[DHH expressed satisfaction](https://groups.google.com/d/msg/rubyonrails-core/6ZPPg1ZmjQA/kTT-GKwew10J) with divergent handling to `has_one` vs `has_many` associations. Obviously, we (politely!) disagree with this assessment.

The "reload before/after" syntax, coupled with the introduction of a dynamic magic method to recover lost functionality would seem to be a net loss. The universal consistency of `@parent.association(true)` also better supports _Least Surprise_ theory.

Looking at the meta, Singular and Collection associations behave differently, but are grouped and handled collectively, both within the Rails core and Rails-powered applications. The close relationship warrants maintaining parity where possible.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. To install this gem onto your local machine, run `bundle exec rake install`.

We use the [appraisal](https://github.com/thoughtbot/appraisal) gem to help us generate the individual Gemfiles for each ActiveRecord version and to run the tests locally against each generated Gemfile. The `bundle exec rake appraisal test` command actually runs our test suite against all Rails versions in our `Appraisal` file. If you want to run the tests for a specific Rails version, use `rake -T` for a list.

```shell
$ bundle exec appraisal activerecord52 rake test
```

We provide a [Vagrant](https://www.vagrantup.com) box to spin up the entire gem in a clean environment. Doing so will avoid the need to prefix all commands with `bundle exec`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/battlebrisket/rails-force-reload.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
