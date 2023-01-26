# SetParser

With this gem you'll can parse text file easily, input a txt file and output a format hash. It was created with this data below:

## Input
```
# This is a comment, ignore it
# All these config lines are valid
host = test.com
server_id=55331
cost=2.56
user= user
# comment can appear here as well
verbose =true
test_mode = on
debug_mode = off
log_file_path = /tmp/logfile.log
send_notifications = yes
```

## Output
```
{
  'host' => 'test.com',
  'server_id' => 55_331,
  'cost' => 2.56,
  'user' => 'user',
  'verbose' => true,
  'test_mode' => true,
  'debug_mode' => false,
  'log_file_path' => '/tmp/logfile.log',
  'send_notifications' => true
}
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'set_parser'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install set_parser

## Use

```
config = ConfigParser.new(filepath: 'your-filepath')
config.call
p config.params
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/igoracportela/set_parser.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
