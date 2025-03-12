# frozen_string_literal: true

require_relative '../controllers/articles'
require_relative '../middleware/auth'

class ArticleRoutes < Sinatra::Base
  use AuthMiddleware

  def initialize
    super
    @articleCtrl = ArticleController.new
  end

  before do
    content_type :json
  end

  get('/') do
    summary = @articleCtrl.get_batch

    if summary[:ok]
      { articles: summary[:data] }.to_json
    else
      status 500
      { msg: 'Could not get articles.' }.to_json
    end
  end

  get('/:id') do
    id = params['id'].to_i
    summary = @articleCtrl.get_article(id)

    if summary[:ok]
      { article: summary[:data] }.to_json
    else
      { msg: summary[:msg] }.to_json
    end
  end

  post('/') do
    payload = JSON.parse(request.body.read)
    summary = @articleCtrl.create_article(payload)

    if summary[:ok]
      { msg: 'Article created', article: summary[:obj] }.to_json
    else
      status 400
      { msg: summary[:msg] }.to_json
    end
  end

  put('/:id') do
    id = params['id'].to_i
    payload = JSON.parse(request.body.read)
    summary = @articleCtrl.update_article(id, payload)

    if summary[:ok]
      { msg: 'Article updated', article: summary[:obj] }.to_json
    else
      status 404
      { msg: summary[:msg] }.to_json
    end
  end

  delete('/:id') do
    id = params['id'].to_i
    summary = @articleCtrl.delete_article(id)

    if summary[:ok]
      { msg: 'Article deleted' }.to_json
    else
      { msg: 'Article does not exist' }.to_json
    end
  end
end
