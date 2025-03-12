# frozen_string_literal: true

require 'json'
require 'base64'

class AuthMiddleware
  def initialize(app)
    @app = app
    @stored_creds = []

    File.foreach('config/.access') do |line|
      @stored_creds.append(line.split('=', 2)[1].strip)
    end
  end

  def call(env)
    auth_header = env['HTTP_AUTHORIZATION']

    return Rack::Response.new('UNAUTHORIZED', 401, {}).finish if auth_header.nil?

    auth_token = auth_header[6..]
    creds = Base64.decode64(auth_token).force_encoding('UTF-8').split(':', 2)

    if creds[0].eql?(@stored_creds[0]) && creds[1].eql?(@stored_creds[1])
      env['AUTHED'] = true
      @app.call(env)
    else
      Rack::Response.new('UNAUTHORIZED', 401, {}).finish
    end
  rescue StandardError
    Rack::Response.new('SOMETHING WENT WRONG!', 501, {}).finish
  end
end
