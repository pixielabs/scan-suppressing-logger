# ScanSuppressingLogger

[![Gem Version](https://badge.fury.io/rb/scan-suppressing-logger.svg)](https://badge.fury.io/rb/scan-suppressing-logger)

Rails middleware to suppress logging and exception reporting for certain IP
addresses or IP address ranges. Useful if your application is the target of
automated security scans (e.g. a scheduled penetration test) that fills your
logs with garbage errors and requests.

Suppresses the standard Rails logging, and also suppresses exception reporting
for:

 - [Rollbar](https://rollbar.com)
 - _Sentry & more coming soon!_

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'scan-suppressing-logger'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scan-suppressing-logger

## Usage

Add to your `config/environments/production.rb`:

```ruby
# config/environments/production.rb
config.middleware.swap Rails::Rack::Logger, ScanSuppressingLogger::Middleware, {
  networks: ['123.0.2.2/24', '86.54.222.1/16']
}
```

Pass an array of IP addresses or networks as strings to suppress logging for.
These should be parseable by
[IPAddr](https://ruby-doc.org/stdlib-2.6.3/libdoc/ipaddr/rdoc/IPAddr.html).

### Help! `No such middleware to insert before: Rails::Rack::Logger`

If you get this error it might be because something else is replacing the
standard logger, or expecting it to be there. For example, if you have
`config.assets.quiet = true` in your configuration, Sprockets tries to
`insert_before` the standard logging middleware in an initializer. You'll need
to configure this gem in an initializer instead:

```ruby
# config/initializer/suppressing_logger.rb
Rails.application.config.middleware.swap Rails::Rack::Logger, ScanSuppressingLogger::Middleware, {
  networks: ['123.0.2.2/24', '86.54.222.1/16']
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/pixielabs/scan-suppressing-logger. This project is intended to
be a safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org) code of
conduct.

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ScanSuppressingLogger project’s codebases, issue
trackers, chat rooms and mailing lists is expected to follow the [code of
conduct](https://github.com/jalada/scan-suppressing-logger/blob/master/CODE_OF_CONDUCT.md).
