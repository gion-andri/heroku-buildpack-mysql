# heroku-buildpack-mysql

This is a [Heroku buildpack](http://devcenter.heroku.com/articles/buildpacks) for vendoring the `mysql` and `mysqldump` binaries from the `mysql-client` deb package.

## Versions

- MySQL: `8.0`

## SSL Library Compatibility

The MySQL 8.0 client is compiled against OpenSSL 1.1, but the Heroku-24 stack ships with OpenSSL 3.0. This causes compatibility issues when trying to run the MySQL client. To resolve this, this buildpack:

1. Downloads the MySQL 8.0 client
2. Downloads and installs libssl1.1 as a dependency
3. Sets up the necessary library paths to ensure the MySQL client can find libssl1.1

## TODO

- MySQL 8.1 and later versions are compatible with OpenSSL 3.0. Try to update this buildpack to use those versions instead.
