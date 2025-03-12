# frozen_string_literal: true

require_relative '../middleware/auth'
require 'sinatra/base'

# Routes for health check endpoints
class HealthRoutes < Sinatra::Base
  use AuthMiddleware

  get('/') do
    if request.env['AUTHED'] == true
      'App working OK'
    else
      status 403
      'Unauthorized'
    end
  end
end
