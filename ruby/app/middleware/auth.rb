# frozen_string_literal: true

require 'json'
require 'base64'

# Middleware for handling Basic Authentication for API access
class AuthMiddleware
  def initialize(app)
    @app = app
    @stored_creds = load_credentials
  end

  # Handles authentication for incoming requests
  def call(env)
    return unauthorized unless auth_header?(env)

    auth_type, credentials = parse_auth_header(env)
    return unauthorized unless auth_type == 'Basic'

    username, password = decode_credentials(credentials)
    return unauthorized unless valid_credentials?(username, password)

    env['AUTHED'] = true
    @app.call(env)
  rescue StandardError => e
    error_response(e)
  end

  private

  def load_credentials
    creds = []
    File.foreach('config/.access') do |line|
      creds.append(line.split('=', 2)[1].strip)
    end
    creds
  end

  def auth_header?(env)
    env['HTTP_AUTHORIZATION']
  end

  def parse_auth_header(env)
    env['HTTP_AUTHORIZATION'].split(' ', 2)
  end

  def decode_credentials(credentials)
    Base64.decode64(credentials).split(':', 2)
  end

  def valid_credentials?(username, password)
    username == @stored_creds[0] && password == @stored_creds[1]
  end

  def unauthorized
    Rack::Response.new('UNAUTHORIZED', 401, {}).finish
  end

  def error_response(error)
    Rack::Response.new("SOMETHING WENT WRONG: #{error.message}", 501, {}).finish
  end
end
