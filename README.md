# Nyarv

Not Yet Another RubyVM.
Work in progress.

## Installation

```bash
git clone https://github.com/nownabe/nyarv.git
```

## Usage

```bash
$ exe/nyarv 'puts "Hello, world!"' 2> /dev/null
Hello, world!
$ exe/nyarv 'print "Hello, nyarv!\n"' 2> /dev/null
Hello, nyarv!
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nownabe/nyarv.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
