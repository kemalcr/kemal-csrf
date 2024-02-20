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

To access the CSRF token of the active session you can do the following in your .ecr form(s)
```html
<input type="hidden" name="authenticity_token" value='<%= env.session.string("csrf") %>'>
```

You can also change the name of the form field, header name, the methods which don't need csrf,error message and routes which you don't want csrf to apply.
All of these are optional
```crystal
require "kemal-csrf"

add_handler CSRF.new(
  header: "X_CSRF_TOKEN",
  allowed_methods: ["GET", "HEAD", "OPTIONS", "TRACE"],
  allowed_routes: ["/api/somecallback", "/api/v1/**"],
  parameter_name: "_csrf", 
  error: "CSRF Error",
  http_only: false,
  samesite: nil,
)
```

If you need to have some logic within your error response, you can also pass it a proc (a pointer to a function)


```crystal
require "kemal-csrf"

add_handler CSRF.new(
  header: "X_CSRF_TOKEN",
  allowed_methods: ["GET", "HEAD", "OPTIONS", "TRACE"],
  allowed_routes: ["/api/somecallback", "/api/v1/**"],
  parameter_name: "_csrf", 
  error: ->myerrorhandler(HTTP::Server::Context)
)

def myerrorhandler(env)
  if env.request.headers["Content-Type"]? == "application/json"
    {"error" => "csrf error"}.to_json
  else
    "<html><head><title>Error</title><body><h1>You cannot post to this route without a valid csrf token</h1></body></html>"
  end
end
```


## Contributing

1. Fork it ( https://github.com/kemalcr/kemal-csrf/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [sdogruyol](https://github.com/sdogruyol) Serdar Dogruyol - creator, maintainer
