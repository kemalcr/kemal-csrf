require "secure_random"
require "kemal"
require "kemal-session"

# This middleware adds CSRF protection to your application.
#
# Returns 403 "Forbidden" unless the current CSRF token is submitted
# with any non-GET/HEAD request.
#
# Without CSRF protection, your app is vulnerable to replay attacks
# where an attacker can re-submit a form.
#
class CSRF < Kemal::Handler
  def initialize(@header = "X_CSRF_TOKEN", @allowed_methods = %w(GET HEAD OPTIONS TRACE), @parameter_name = "authenticity_token", @error = "Forbidden", @allowed_routes = [] of String)
    @allowed_routes.each do |path|
      class_name = {{@type.name}}
      %w(GET HEAD OPTIONS TRACE PUT POST).each do |method|
        @@exclude_routes_tree.add "#{class_name}/#{method.downcase}#{path}", "/#{method.downcase}#{path}"
      end
    end
  end

  def call(context)
    return call_next(context) if exclude_match?(context)
    unless context.session.string?("csrf")
      csrf_token = SecureRandom.hex(16)
      context.session.string("csrf", csrf_token)
      context.response.cookies << HTTP::Cookie.new(
        name: @parameter_name,
        value: csrf_token,
        expires: Time.now.to_utc + Kemal::Session.config.timeout,
        http_only: false
      )
    end

    return call_next(context) if @allowed_methods.includes?(context.request.method)
    req = context.request
    submitted = if req.headers[@header]?
                  req.headers[@header]
                elsif context.params.body[@parameter_name]?
                  context.params.body[@parameter_name]
                else
                  "nothing"
                end
    current_token = context.session.string("csrf")
    if current_token == submitted
      # reset the token so it can't be used again
      # context.session.string("csrf", SecureRandom.hex(16))
      return call_next(context)
    else
      context.response.status_code = 403
      context.response.print @error
    end
  end
end
