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
  def initialize(@header = "X_CSRF_TOKEN", @allowed_methods = %w(GET HEAD OPTIONS TRACE), @parameter_name = "authenticity_token", @error = "Forbidden")
  end

  def call(context)
    unless context.session.string?("csrf")
      p "recreating csrf"
      context.session.string("csrf", SecureRandom.hex(16))
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
      p "CSRF don't match", current_token, submitted
      context.response.status_code = 403
      context.response.print @error
    end
  end
end
