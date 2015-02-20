# Contributing

This repository uses [gitflow](https://github.com/nvie/gitflow). Please use the
default settings.

Contributions are welcome. Please consider writing a test that supports your
change. If you don't have time, please consider [raising an issue]
(https://github.com/Kinvey/simple-auth-link/issues/new) to backfill a test.

## Releasing

Please follow the release procedure outlined below. The PR is a good place to
prepare the release note and make last minute changes/fixes to the releasable.

```
git flow release start vx.x.x
npm version patch | minor | major --no-git-tag-version
git commit -am 'version bump'
git flow release publish vx.x.x
# open a pr from release/vx.x.x to master
# use the pr to prepare the release note and make last-minute changes
git flow release finish vx.x.x
git push && git push --tags
```
