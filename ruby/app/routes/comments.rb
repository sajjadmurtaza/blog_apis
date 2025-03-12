# frozen_string_literal: true

require_relative '../controllers/comments'
require_relative '../middleware/auth'

# Routes for comment operations following RESTful conventions
class CommentRoutes < Sinatra::Base
  use AuthMiddleware

  def initialize
    super
    @comment_controller = CommentController.new
  end

  before do
    content_type :json
  end

  # Filter to parse ID parameter
  before '/:id' do
    @id = params['id'].to_i
  end

  # GET /comments - List all comments
  get('/') do
    result = @comment_controller.index

    if result[:ok]
      { comments: result[:data] }.to_json
    else
      status 500
      { msg: result[:msg] || 'Could not get comments.' }.to_json
    end
  end

  # GET /comments/article/:article_id - List comments for a specific article
  get('/article/:article_id') do
    article_id = params['article_id'].to_i
    result = @comment_controller.index(article_id)

    if result[:ok]
      { comments: result[:data] }.to_json
    else
      status 404
      { msg: result[:msg] }.to_json
    end
  end

  # GET /comments/:id - Get a specific comment
  get('/:id') do
    result = @comment_controller.show(@id)

    if result[:ok]
      { comment: result[:data] }.to_json
    else
      status 404
      { msg: result[:msg] }.to_json
    end
  end

  # POST /comments - Create a new comment
  post('/') do
    payload = JSON.parse(request.body.read)
    result = @comment_controller.create(payload)

    if result[:ok]
      status 201
      { msg: 'Comment created', comment: result[:obj] }.to_json
    else
      status 400
      { msg: result[:msg] }.to_json
    end
  rescue JSON::ParserError
    status 400
    { msg: 'Invalid JSON payload' }.to_json
  end

  # PUT /comments/:id - Update a comment
  put('/:id') do
    payload = JSON.parse(request.body.read)
    result = @comment_controller.update(@id, payload)

    if result[:ok]
      { msg: 'Comment updated', comment: result[:obj] }.to_json
    else
      status 404
      { msg: result[:msg] }.to_json
    end
  rescue JSON::ParserError
    status 400
    { msg: 'Invalid JSON payload' }.to_json
  end

  # DELETE /comments/:id - Delete a comment
  delete('/:id') do
    result = @comment_controller.destroy(@id)

    if result[:ok]
      { msg: 'Comment deleted' }.to_json
    else
      status 404
      { msg: 'Comment does not exist' }.to_json
    end
  end
end
