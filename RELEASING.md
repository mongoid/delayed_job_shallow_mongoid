# Releasing delayed_job_shallow_mongoid

Publishing requires push access to the canonical `mongoid/delayed_job_shallow_mongoid` repository, RubyGems ownership, and RubyGems multi-factor authentication. Use Ruby 3.3 or newer for the default development bundle.

## Prepare the release

Start with a clean checkout and confirm that `origin` points to the canonical repository, not a fork:

```sh
git remote get-url origin
git switch master
git pull --ff-only origin master
git status --short
```

Set `Delayed::ShallowMongoid::VERSION` in `lib/delayed/shallow_mongoid/version.rb`. Replace `(Next)` in `CHANGELOG.md` with the release date in `YYYY-MM-DD` format and remove the contribution placeholder from that release. Preserve the linked pull requests and contributor credits.

Install dependencies if needed, start MongoDB, and run the existing lint and integration suite:

```sh
bundle install
bundle exec rake
```

The suite purges and drops its database. Use only a disposable test database; set `MONGODB_URI` to isolate it from other applications.

Build the gem and inspect its version and packaged files:

```sh
bundle exec rake build
gem specification pkg/delayed_job_shallow_mongoid-1.3.0.gem version
gem specification pkg/delayed_job_shallow_mongoid-1.3.0.gem files
```

Substitute the release version in these commands. Confirm the minimum Ruby requirement and supported dependency combinations, then commit and push the preparation:

```sh
git add CHANGELOG.md README.md RELEASING.md lib/delayed/shallow_mongoid/version.rb
git commit -m "Prepare delayed_job_shallow_mongoid 1.3.0"
git push origin master
```

Wait for the exact release commit's [Tests](https://github.com/mongoid/delayed_job_shallow_mongoid/actions/workflows/test.yml) and [Rubocop](https://github.com/mongoid/delayed_job_shallow_mongoid/actions/workflows/rubocop.yml) workflows to pass, including every compatibility job and coverage finalization. Danger runs on pull requests, not direct pushes to `master`; require it when preparing a release through a PR.

## Publish and verify

Confirm that the version is not already published, the version tag does not exist, and the worktree is clean. Immediately before publishing, obtain a fresh RubyGems one-time password from the maintainer. Never reuse a previous release's OTP or write credentials or OTPs into repository files.

```sh
bundle exec rake release
```

Supply the fresh OTP when requested. Bundler builds the gem, creates and pushes the version tag, and publishes to RubyGems. If publishing fails after the tag was pushed, diagnose the failure and resume with `gem push pkg/delayed_job_shallow_mongoid-1.3.0.gem`; never move an existing release tag.

Verify the version, SHA-256 checksum, and remote tag against the exact artifact and release commit:

```sh
shasum -a 256 pkg/delayed_job_shallow_mongoid-1.3.0.gem
curl --fail https://rubygems.org/api/v2/rubygems/delayed_job_shallow_mongoid/versions/1.3.0.json
git ls-remote origin 'refs/tags/v1.3.0*'
```

Create a public, non-draft GitHub release from the existing tag using the matching changelog section:

```sh
gh release create v1.3.0 --repo mongoid/delayed_job_shallow_mongoid \
  --verify-tag --title "delayed_job_shallow_mongoid 1.3.0" \
  --notes-file /path/to/release-notes.txt
```

## Prepare the next development version

Only after verifying publication, bump the version to the next patch iteration, such as `1.3.1`, and prepend an empty changelog section:

```markdown
1.3.1 (Next)
------------

* Your contribution here.
```

Verify the new version loads, commit the version and changelog changes, and push `master` normally. Never force-push `master` or overwrite a published gem or release tag.
