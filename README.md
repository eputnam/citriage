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

Simply run:
```shell
ci-triage
```

To specify specific platforms, list them as arguments separated by spaces:
```shell
ci-triage linux windows netdev
```
Available Plaforms:
windows
linux
cross-platform
netdev
cloud

Default behavior is to list all platforms.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[eputnam]/citriage.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

