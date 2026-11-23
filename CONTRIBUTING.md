# Contributing to `delayed_job_shallow_mongoid`

Contributions are encouraged; please work on a feature branch and open a pull request.

## Development

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

Run `bundle exec rake lint` to check Ruby, Markdown, YAML, and spelling on MRI Ruby 3.3 or newer. Add reviewed project vocabulary to `.spellcheck.txt`, use one line per Markdown paragraph, and use title case for headings.

## Changelog

Add user-facing changes to the next release in `CHANGELOG.md`, linking the issue or pull request and crediting the contributor. Danger checks new and edited entries without reformatting historical releases, and reminds contributors to update the changelog; README-only changes are exempt. Changelog review runs separately on Ruby 3.4 and publishes a report on pull requests, including forks, using GitHub's built-in token; no personal access token or shared Mongoid Danger gem is required.
