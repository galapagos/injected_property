# InjectedProperty

injected_property is gem making it possible to inject processing for accessors.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'injected_property', github: galapagos/injected_property
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install injected_property -l 'git://github.com/galapagos/injected_property'

## Usage

```rb
class Sample
  include InjectedProperty

  injected_accessors :foo, :bar, # defined attributes.
                     # executed before a set.
                     before_set: ->(instance, set_value) {
                       puts 'before set'
                     },
                     # set the value that this Proc returns.
                     inject_set: ->(instance, set_value) {
                       set_value.upcase
                     },
                     # executed after a set.
                     after_set: ->(instance, set_value) {
                       puts 'after set'
                     },

  injected_accessors :baz,
                     # executed before a get.
                     before_get: ->(instance, get_value) {
                       puts 'before get'
                     }
                     # get the value that this Proc returns.
                     inject_get: ->(instance, get_value) {
                       get_value.size
                     },
                     # executed after a get.
                     after_get: ->(instance, get_value) {
                       puts 'after get'
                     }
end

sample = Samile.new

sample.foo = 'foo'
# => 'before set'
# => 'after set'

p sample.foo
# => 'FOO'

sample.baz = 'baz'
p sample.baz
# => 'before get'
# => 3
# => 'after get'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
