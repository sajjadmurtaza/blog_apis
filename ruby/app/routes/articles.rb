# frozen_string_literal: true

require_relative '../controllers/articles'
require_relative '../middleware/auth'

# Routes for article operations following RESTful conventions
class ArticleRoutes < Sinatra::Base
  use AuthMiddleware

  def initialize
    super
    @article_controller = ArticleController.new
  end

  before do
    content_type :json
  end

  # Filter to parse ID parameter
  before '/:id' do
    @id = params['id'].to_i
  end

  # GET /articles - List all articles
  get('/') do
    result = @article_controller.index

    if result[:ok]
      { articles: result[:data] }.to_json
    else
      status 500
      { msg: result[:msg] || 'Could not get articles.' }.to_json
    end
  end

  # GET /articles/:id - Get a specific article
  get('/:id') do
    result = @article_controller.show(@id)

    if result[:ok]
      { article: result[:data] }.to_json
    else
      { msg: result[:msg] }.to_json
    end
  end

  # POST /articles - Create a new article
  post('/') do
    payload = JSON.parse(request.body.read)
    result = @article_controller.create(payload)

    if result[:ok]
      { msg: 'Article created', article: result[:obj] }.to_json
    else
      status 400
      { msg: result[:msg] }.to_json
    end
  rescue JSON::ParserError
    status 400
    { msg: 'Invalid JSON payload' }.to_json
  end

  # PUT /articles/:id - Update an article
  put('/:id') do
    payload = JSON.parse(request.body.read)
    result = @article_controller.update(@id, payload)

    if result[:ok]
      { msg: 'Article updated', article: result[:obj] }.to_json
    else
      { msg: result[:msg] }.to_json
    end
  rescue JSON::ParserError
    status 400
    { msg: 'Invalid JSON payload' }.to_json
  end

  # DELETE /articles/:id - Delete an article
  delete('/:id') do
    result = @article_controller.destroy(@id)
    if result[:ok]
      { msg: 'Article deleted' }.to_json
    else
      { msg: 'Article does not exist' }.to_json
    end
  end
end
