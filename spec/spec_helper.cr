require "spec"
require "../src/kemal-csrf"
Kemal::Session.config.secret = "my_super_secret"
def create_request_and_return_io(handler, request)
  io = IO::Memory.new
  response = HTTP::Server::Response.new(io)
  context = HTTP::Server::Context.new(request, response)
  handler.call(context)
  response.close
  io.rewind
  io
end
