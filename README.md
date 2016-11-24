# kemal-csrf

Adds CSRF protection to your [Kemal](http://kemalcr.com) application.

Requires a session middleware to be initialized first.

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  kemal-csrf:
    github: kemalcr/kemal-csrf
```


## Usage


```crystal
require "kemal-csrf"

add_handler CSRF.new
```

## Contributing

1. Fork it ( https://github.com/kemalcr/kemal-csrf/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [sdogruyol](https://github.com/sdogruyol) Serdar Dogruyol - creator, maintainer
