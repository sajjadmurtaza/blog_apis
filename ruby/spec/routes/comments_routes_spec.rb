# frozen_string_literal: true

require 'rspec/autorun'
require 'sinatra/base'
require 'rack/test'
require 'json'
require 'securerandom'
require_relative '../../config/environment'
require_relative '../../app/models/db_init'
require_relative '../../app/routes/comments'
require_relative '../../app/middleware/auth'

describe CommentRoutes do
  include Rack::Test::Methods

  def app
    CommentRoutes
  end

  before(:all) do
    # Create a test article and comments with a unique title
    @article = Article.create!(
      title: "Test Article for Routes #{SecureRandom.hex(8)}",
      content: 'Test Content'
    )
    @comment1 = Comment.create!(
      article_id: @article.id,
      content: 'First test comment',
      author_name: 'John Doe',
      created_at: Time.now
    )
    @comment2 = Comment.create!(
      article_id: @article.id,
      content: 'Second test comment',
      author_name: 'Jane Smith',
      created_at: Time.now
    )
  end

  describe 'GET /' do
    it 'returns all comments' do
      authorize 'applicant', 'pass'
      get '/'

      expect(last_response.status).to eq(200)

      response_body = JSON.parse(last_response.body)
      expect(response_body).to have_key('comments')
      expect(response_body['comments']).to be_an(Array)
      expect(response_body['comments'].length).to be >= 2
    end

    it 'requires authentication' do
      get '/'
      expect(last_response.status).to eq(401)
    end
  end

  describe 'GET /article/:article_id' do
    it 'returns comments for a specific article' do
      authorize 'applicant', 'pass'
      get "/article/#{@article.id}"

      expect(last_response.status).to eq(200)

      response_body = JSON.parse(last_response.body)
      expect(response_body).to have_key('comments')
      expect(response_body['comments']).to be_an(Array)
      expect(response_body['comments'].length).to be >= 2

      # Check that all comments belong to the article
      article_ids = response_body['comments'].map { |c| c['article_id'] }
      expect(article_ids.all? { |id| id == @article.id }).to be true
    end

    it 'returns 404 for non-existent article' do
      authorize 'applicant', 'pass'
      get '/article/999'

      expect(last_response.status).to eq(404)

      response_body = JSON.parse(last_response.body)
      expect(response_body).to have_key('msg')
      expect(response_body['msg']).to eq('Article not found')
    end
  end

  describe 'GET /:id' do
    it 'returns a specific comment' do
      authorize 'applicant', 'pass'
      get "/#{@comment1.id}"

      expect(last_response.status).to eq(200)

      response_body = JSON.parse(last_response.body)
      expect(response_body).to have_key('comment')
      expect(response_body['comment']).to be_a(Hash)
      expect(response_body['comment']['id']).to eq(@comment1.id)
      expect(response_body['comment']['content']).to eq(@comment1.content)
      expect(response_body['comment']['author_name']).to eq(@comment1.author_name)
    end

    it 'returns 404 for non-existent comment' do
      authorize 'applicant', 'pass'
      get '/999'

      expect(last_response.status).to eq(404)

      response_body = JSON.parse(last_response.body)
      expect(response_body).to have_key('msg')
      expect(response_body['msg']).to eq('Comment not found')
    end
  end

  describe 'POST /' do
    it 'creates a new comment' do
      authorize 'applicant', 'pass'

      comment_data = {
        article_id: @article.id,
        content: 'New comment from route test',
        author_name: 'Route Tester'
      }.to_json

      post '/', comment_data, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq(201)

      response_body = JSON.parse(last_response.body)
      expect(response_body).to have_key('msg')
      expect(response_body['msg']).to eq('Comment created')
      expect(response_body).to have_key('comment')
      expect(response_body['comment']).to be_a(Hash)
      expect(response_body['comment']['content']).to eq('New comment from route test')
      expect(response_body['comment']['author_name']).to eq('Route Tester')
    end

    it 'returns 400 for invalid parameters' do
      authorize 'applicant', 'pass'

      comment_data = {
        article_id: @article.id,
        content: '',
        author_name: 'Route Tester'
      }.to_json

      post '/', comment_data, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq(400)

      response_body = JSON.parse(last_response.body)
      expect(response_body).to have_key('msg')
    end
  end

  describe 'PUT /:id' do
    it 'updates an existing comment' do
      authorize 'applicant', 'pass'

      comment_data = {
        content: 'Updated comment from route test',
        author_name: 'Updated Author'
      }.to_json

      put "/#{@comment2.id}", comment_data, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq(200)

      response_body = JSON.parse(last_response.body)
      expect(response_body).to have_key('msg')
      expect(response_body['msg']).to eq('Comment updated')
      expect(response_body).to have_key('comment')
      expect(response_body['comment']).to be_a(Hash)
      expect(response_body['comment']['content']).to eq('Updated comment from route test')
      expect(response_body['comment']['author_name']).to eq('Updated Author')
    end

    it 'returns 404 for non-existent comment' do
      authorize 'applicant', 'pass'

      comment_data = {
        content: 'Updated content',
        author_name: 'Updated Author'
      }.to_json

      put '/999', comment_data, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq(404)

      response_body = JSON.parse(last_response.body)
      expect(response_body).to have_key('msg')
      expect(response_body['msg']).to eq('Comment not found')
    end
  end

  describe 'DELETE /:id' do
    it 'deletes an existing comment' do
      authorize 'applicant', 'pass'

      # Create a comment to delete
      comment = Comment.create(
        article_id: @article.id,
        content: 'Comment to delete',
        author_name: 'Delete Tester',
        created_at: Time.now
      )

      delete "/#{comment.id}"

      expect(last_response.status).to eq(200)

      response_body = JSON.parse(last_response.body)
      expect(response_body).to have_key('msg')
      expect(response_body['msg']).to eq('Comment deleted')

      # Verify the comment was deleted
      expect(Comment.find_by(id: comment.id)).to be_nil
    end

    it 'returns 404 for non-existent comment' do
      authorize 'applicant', 'pass'

      delete '/999'

      expect(last_response.status).to eq(404)

      response_body = JSON.parse(last_response.body)
      expect(response_body).to have_key('msg')
      expect(response_body['msg']).to eq('Comment does not exist')
    end
  end
end
