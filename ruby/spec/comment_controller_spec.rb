# frozen_string_literal: true

require 'rspec/autorun'
require 'securerandom'
require_relative '../config/environment'
require_relative '../app/models/db_init'
require_relative '../app/controllers/comments'

describe CommentController do
  let(:controller) { CommentController.new }
  let(:article) do
    Article.create!(
      title: "Test Article #{SecureRandom.hex(8)}",
      content: 'Test Content'
    )
  end

  describe '#index' do
    it 'gets all comments' do
      result = controller.index
      expect(result).to have_key(:ok)
      expect(result[:ok]).to be true
      expect(result).to have_key(:data)
      expect(result[:data]).to respond_to(:each)
    end

    it 'gets comments for a specific article' do
      # Create some comments for the article
      Comment.create!(article_id: article.id, content: 'First comment', author_name: 'John')
      Comment.create!(article_id: article.id, content: 'Second comment', author_name: 'Jane')

      result = controller.index(article.id)

      expect(result).to have_key(:ok)
      expect(result[:ok]).to be true
      expect(result).to have_key(:data)
      expect(result[:data]).to respond_to(:each)
      expect(result[:data].length).to be >= 2
      expect(result[:data].all? { |c| c.article_id == article.id }).to be true
    end
  end

  describe '#show' do
    it 'gets a specific comment' do
      comment = Comment.create!(article_id: article.id, content: 'Test comment', author_name: 'John')

      result = controller.show(comment.id)

      expect(result).to have_key(:ok)
      expect(result[:ok]).to be true
      expect(result).to have_key(:data)
      expect(result[:data]).to be_a(Comment)
      expect(result[:data].id).to eq(comment.id)
    end

    it 'returns an error for non-existent comment' do
      result = controller.show(999)

      expect(result).to have_key(:ok)
      expect(result[:ok]).to be false
      expect(result).to have_key(:msg)
      expect(result[:msg]).to eq('Comment not found')
    end
  end

  describe '#create' do
    it 'creates a new comment' do
      params = {
        'article_id' => article.id,
        'content' => 'New comment from controller test',
        'author_name' => 'Test User'
      }

      result = controller.create(params)

      expect(result).to have_key(:ok)
      expect(result[:ok]).to be true
      expect(result).to have_key(:obj)
      expect(result[:obj]).to be_a(Comment)
      expect(result[:obj].content).to eq('New comment from controller test')
      expect(result[:obj].author_name).to eq('Test User')
    end

    it 'returns an error with invalid parameters' do
      params = {
        'article_id' => article.id,
        'content' => '',
        'author_name' => 'Test User'
      }

      result = controller.create(params)

      expect(result).to have_key(:ok)
      expect(result[:ok]).to be false
      expect(result).to have_key(:msg)
    end
  end

  describe '#update' do
    it 'updates an existing comment' do
      comment = Comment.create!(article_id: article.id, content: 'Original content', author_name: 'John')
      params = {
        'content' => 'Updated content from controller test',
        'author_name' => 'Updated Author'
      }

      result = controller.update(comment.id, params)

      expect(result).to have_key(:ok)
      expect(result[:ok]).to be true
      expect(result).to have_key(:obj)
      expect(result[:obj]).to be_a(Comment)
      expect(result[:obj].content).to eq('Updated content from controller test')
      expect(result[:obj].author_name).to eq('Updated Author')
    end

    it 'returns an error for non-existent comment' do
      params = { 'content' => 'Updated content' }

      result = controller.update(999, params)

      expect(result).to have_key(:ok)
      expect(result[:ok]).to be false
      expect(result).to have_key(:msg)
      expect(result[:msg]).to eq('Comment not found')
    end
  end

  describe '#destroy' do
    it 'deletes an existing comment' do
      comment = Comment.create!(article_id: article.id, content: 'Comment to delete', author_name: 'John')

      result = controller.destroy(comment.id)

      expect(result).to have_key(:ok)
      expect(result[:ok]).to be true
      expect(result).to have_key(:delete_count)
      expect(result[:delete_count]).to eq(1)
      expect(Comment.find_by(id: comment.id)).to be_nil
    end

    it 'returns an error for non-existent comment' do
      result = controller.destroy(999)

      expect(result).to have_key(:ok)
      expect(result[:ok]).to be false
      expect(result).to have_key(:msg)
      expect(result[:msg]).to eq('Comment not found')
    end
  end

  describe 'alias methods' do
    it 'get_batch is an alias for index' do
      expect(controller.method(:get_batch)).to eq(controller.method(:index))
    end

    it 'get_comment is an alias for show' do
      expect(controller.method(:get_comment)).to eq(controller.method(:show))
    end

    it 'add_comment is an alias for create' do
      expect(controller.method(:add_comment)).to eq(controller.method(:create))
    end

    it 'update_comment is an alias for update' do
      expect(controller.method(:update_comment)).to eq(controller.method(:update))
    end

    it 'delete_comment is an alias for destroy' do
      expect(controller.method(:delete_comment)).to eq(controller.method(:destroy))
    end
  end
end
