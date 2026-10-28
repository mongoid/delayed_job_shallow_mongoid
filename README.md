delayed_job_shallow_mongoid
===========================

[![Tests](https://github.com/mongoid/delayed_job_shallow_mongoid/actions/workflows/test.yml/badge.svg)](https://github.com/mongoid/delayed_job_shallow_mongoid/actions/workflows/test.yml)
[![Rubocop](https://github.com/mongoid/delayed_job_shallow_mongoid/actions/workflows/rubocop.yml/badge.svg)](https://github.com/mongoid/delayed_job_shallow_mongoid/actions/workflows/rubocop.yml)
[![Coverage Status](https://coveralls.io/repos/github/mongoid/delayed_job_shallow_mongoid/badge.svg?branch=master)](https://coveralls.io/github/mongoid/delayed_job_shallow_mongoid?branch=master)
[![Gem Version](https://badge.fury.io/rb/delayed_job_shallow_mongoid.svg)](https://rubygems.org/gems/delayed_job_shallow_mongoid)

This library short-circuits serialization of [Mongoid](https://www.mongodb.com/docs/mongoid/current/) model instances when a delayed job is called on them, or when they're passed as arguments to a delayed job. Rather than generate and store the fully-serialized YAML, a simple stub is stored. When the job is run, the stub is recognized and a `find` is done to look up the underlying document. If a referenced model isn't found at this point, the job simply does nothing.

Requires Ruby 2.7 or newer. CI exercises Mongoid 6-9, Rails 5.2/6.1/7.2/8.0/8.1, and Ruby 2.7/3.3/3.4/4.0 in compatible combinations. Mongoid 6 and 7 are tested with MongoDB 4.4; Mongoid 8 and 9 use MongoDB 8.0. Legacy combinations are compatibility checks, not recommendations for new applications.

Development
-----------

The default bundle uses Mongoid 9 and Rails 8.1. Use Ruby 3.3 or newer and start MongoDB before running the suite:

```sh
bundle install
bundle exec rake
```

Tests use `mongodb://127.0.0.1:27017/delayed_job_shallow_mongoid_test` by default. Override `MONGODB_URI` to use an isolated test database. **The suite purges and drops this database; never point it at development or production data.**

To select another compatible dependency combination:

```sh
MONGOID_VERSION='~> 8.1' RAILS_VERSION='~> 7.2' bundle update
MONGOID_VERSION='~> 8.1' RAILS_VERSION='~> 7.2' bundle exec rake
```

Every test run writes HTML coverage to `coverage/index.html` and LCOV coverage to `coverage/lcov.info`, enforcing at least 90% line and 80% branch coverage. GitHub Actions uploads coverage artifacts and reports the compatibility jobs to Coveralls.

Contributions
-------------

* Contributions encouraged. Feature branches appreciated.
* Development generously supported by [Artsy](https://www.artsy.net).

Copyright
---------

Copyright (c) 2011-2015 Joey Aghion, Artsy Inc.

MIT License. See [LICENSE](LICENSE.txt) for further details.
