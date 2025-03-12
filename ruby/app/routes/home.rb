# frozen_string_literal: true

# Routes for the home page and root endpoints
class HomeRoutes < Sinatra::Base
  set :root,  File.dirname(__FILE__)
  set :views, proc { File.join(root, '..', 'views') }

  get('/') do
    erb :home
  end
end
