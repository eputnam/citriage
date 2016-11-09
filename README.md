# Citriage

Lists out modules from Jenkins and their current status as it pertains ot CI Triage rotation.

## Installation

Build the gem:
```shell
gem build citriage.gemspec
```

Install the gem:
```shell
gem install {gem_file}
```

## Usage

To list modules for all platforms, simply run:
```shell
ci-triage
```

To get verbose output that lists all branches and failing jobs individually, run with the `--verbose` option:
```shell
ci-triage --verbose
```

To take it to the _next_ level and list failing configurations per job, run with the `--configurations` option:
```shell
ci-triage --configurations
```

To specify specific platforms, use the -p option and list platforms as arguments separated by commas:
```shell
ci-triage -p linux,windows,netdev
```

### Available Plaforms:
- windows
- linux
- cross-platform
- netdev
- cloud

Default behavior is to list all platforms.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eputnam/citriage.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

