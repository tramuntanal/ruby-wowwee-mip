# Wowwee::Mip

Ruby library to control the Wowwee Mip robot through Bluetooth Low Energy.

## Requirements
```ruby-ble``` gem which in turn has this requirements:
- ruby >= 2.3
- Dbus
- bluez >= 5.36 (available on debian testing)
- bluetoothd started with option -E (experimental)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wowwee-mip'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wowwee-mip

## Usage

Instantiate the robot:
```ruby
ble_address= '1C:05:B3:7D:95:74'
mip= Wowwee.mip(ble_address)
```
See status:
```ruby
status= mip.status
puts status.battery_level   => 50
puts mip.game_mode          => :default
```
Play:
```ruby
mip.set_head_led(:bfast, :bslow, :bslow, :bfast)
mip.drive_forward(speed: 30, times: 200)
sleep(1)
mip.stop
```

## Examples
For usage examples and implemented features see the specs.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tramuntanal/ruby-wowwee-mip. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

