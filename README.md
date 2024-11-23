# heroku-buildpack-mysql

This is a [Heroku buildpack](http://devcenter.heroku.com/articles/buildpacks) for vendoring the `mysql` and `mysqldump` binaries from the official MySQL repository.

## Versions

- MySQL: `8.4 LTS`
- Platform: Ubuntu 24.04
- OpenSSL: 3.0 compatible

## Package Details

This buildpack installs the `mysql-community-client-core` package from the official MySQL repository, which includes:

- `mysql` client
- `mysqldump` utility

The current version uses MySQL 8.4 LTS which is natively compatible with OpenSSL 3.0, eliminating the need for additional SSL library dependencies.
