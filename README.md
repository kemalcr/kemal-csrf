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

Basic Use
```crystal
require "kemal-csrf"

add_handler CSRF.new
```
You can also change the name of the form field, header name, the methods which don't need csrf and error message.
All of these are optional
```crystal
require "kemal-csrf"

add_handler CSRF.new(header: "X_CSRF_TOKEN",allowed_methods: ["GET", "HEAD", "OPTIONS", "TRACE"],parameter_name: "_csrf", error: "CSRF Error" )
```

## Contributing

1. Fork it ( https://github.com/kemalcr/kemal-csrf/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [sdogruyol](https://github.com/sdogruyol) Serdar Dogruyol - creator, maintainer
