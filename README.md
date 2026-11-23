# DelayedJob Shallow Mongoid

[![Tests](https://github.com/mongoid/delayed_job_shallow_mongoid/actions/workflows/test.yml/badge.svg)](https://github.com/mongoid/delayed_job_shallow_mongoid/actions/workflows/test.yml) [![Lint](https://github.com/mongoid/delayed_job_shallow_mongoid/actions/workflows/lint.yml/badge.svg)](https://github.com/mongoid/delayed_job_shallow_mongoid/actions/workflows/lint.yml) [![Coverage Status](https://coveralls.io/repos/github/mongoid/delayed_job_shallow_mongoid/badge.svg?branch=master)](https://coveralls.io/github/mongoid/delayed_job_shallow_mongoid?branch=master) [![Gem Version](https://badge.fury.io/rb/delayed_job_shallow_mongoid.svg)](https://rubygems.org/gems/delayed_job_shallow_mongoid)

This library short-circuits serialization of [Mongoid](https://www.mongodb.com/docs/mongoid/current/) model instances when a delayed job is called on them, or when they're passed as arguments to a delayed job. Rather than generate and store the fully-serialized YAML, a simple stub is stored. When the job is run, the stub is recognized and a `find` is done to look up the underlying document. If a referenced model isn't found at this point, the job simply does nothing.

Requires Ruby 2.7 or newer. CI exercises Mongoid 6-9, Rails 5.2/6.1/7.2/8.0/8.1, and Ruby 2.7/3.3/3.4/4.0 in compatible combinations. Mongoid 6 and 7 are tested with MongoDB 4.4; Mongoid 8 and 9 use MongoDB 8.0. Legacy combinations are compatibility checks, not recommendations for new applications.

## Installation

Add the gem to your Gemfile next to `delayed_job` and `delayed_job_mongoid`, then run `bundle install`.

```ruby
gem 'delayed_job_shallow_mongoid'
```

No configuration is needed: delayed jobs on Mongoid documents, and delayed jobs with Mongoid documents as arguments, store document stubs automatically.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md), [CHANGELOG.md](CHANGELOG.md), and [RELEASING.md](RELEASING.md). Development is generously supported by [Artsy](https://www.artsy.net).

## Copyright

Copyright (c) 2011-2015 Joey Aghion, Artsy Inc.

MIT License. See [LICENSE.txt](LICENSE.txt) for further details.
