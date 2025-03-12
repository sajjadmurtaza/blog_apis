# frozen_string_literal: true

require 'rspec/autorun'
require 'securerandom'
require_relative '../../config/environment'
require_relative '../../app/models/db_init'
require_relative '../../app/services/comment_service'

describe CommentService do
  # Use a unique title for each test to avoid validation errors
  let(:article) do
    Article.create!(
      title: "Test Article #{SecureRandom.hex(8)}",
      content: 'Test Content'
    )
  end

  describe '.all' do
    it 'returns all comments' do
      result = CommentService.all
      expect(result[:ok]).to be true
      # Change expectation to allow ActiveRecord::Relation
      expect(result[:data]).to respond_to(:each)
    end

    it 'returns comments for a specific article' do
      # Create some comments for the article
      Comment.create!(article_id: article.id, content: 'First comment', author_name: 'John')
      Comment.create!(article_id: article.id, content: 'Second comment', author_name: 'Jane')

      result = CommentService.all(article.id)

      expect(result[:ok]).to be true
      # Change expectation to allow ActiveRecord::Relation
      expect(result[:data]).to respond_to(:each)
      expect(result[:data].length).to be >= 2
      expect(result[:data].all? { |c| c.article_id == article.id }).to be true
    end

    it 'returns an error when article does not exist' do
      result = CommentService.all(999)
      expect(result[:ok]).to be false
      expect(result[:msg]).to eq('Article not found')
    end
  end

  describe '.find' do
    it 'returns a comment when it exists' do
      comment = Comment.create!(article_id: article.id, content: 'Test comment', author_name: 'John')

      result = CommentService.find(comment.id)

      expect(result[:ok]).to be true
      expect(result[:data]).to be_a(Comment)
      expect(result[:data].id).to eq(comment.id)
    end

    it 'returns an error when comment does not exist' do
      result = CommentService.find(999)
      expect(result[:ok]).to be false
      expect(result[:msg]).to eq('Comment not found')
    end
  end

  describe '.create' do
    it 'creates a new comment with valid parameters' do
      params = {
        'article_id' => article.id,
        'content' => 'New test comment',
        'author_name' => 'Test User'
      }

      result = CommentService.create(params)

      expect(result[:ok]).to be true
      expect(result[:obj]).to be_a(Comment)
      expect(result[:obj].content).to eq('New test comment')
      expect(result[:obj].author_name).to eq('Test User')
      expect(result[:obj].article_id).to eq(article.id)
    end

    it 'returns an error with invalid parameters' do
      params = {
        'article_id' => article.id,
        'content' => '',
        'author_name' => 'Test User'
      }

      result = CommentService.create(params)

      expect(result[:ok]).to be false
      expect(result[:msg]).to include("Content can't be blank")
    end

    it 'returns an error when article does not exist' do
      params = {
        'article_id' => 999,
        'content' => 'Comment for non-existent article',
        'author_name' => 'Test User'
      }

      result = CommentService.create(params)

      expect(result[:ok]).to be false
      expect(result[:msg]).to eq('Article not found')
    end
  end

  describe '.update' do
    it 'updates a comment when it exists' do
      comment = Comment.create!(article_id: article.id, content: 'Original content', author_name: 'John')
      params = {
        'content' => 'Updated content',
        'author_name' => 'Updated Author'
      }

      result = CommentService.update(comment.id, params)

      expect(result[:ok]).to be true
      expect(result[:obj]).to be_a(Comment)
      expect(result[:obj].content).to eq('Updated content')
      expect(result[:obj].author_name).to eq('Updated Author')
    end

    it 'returns an error when comment does not exist' do
      params = { 'content' => 'Updated content' }
      result = CommentService.update(999, params)

      expect(result[:ok]).to be false
      expect(result[:msg]).to eq('Comment not found')
    end

    it 'returns an error when trying to update to a non-existent article' do
      comment = Comment.create!(article_id: article.id, content: 'Original content', author_name: 'John')
      params = { 'article_id' => 999 }

      result = CommentService.update(comment.id, params)

      expect(result[:ok]).to be false
      expect(result[:msg]).to eq('Article not found')
    end
  end

  describe '.delete' do
    it 'deletes a comment when it exists' do
      comment = Comment.create!(article_id: article.id, content: 'Comment to delete', author_name: 'John')

      result = CommentService.delete(comment.id)

      expect(result[:ok]).to be true
      expect(result[:delete_count]).to eq(1)
      expect(Comment.find_by(id: comment.id)).to be_nil
    end

    it 'returns an error when comment does not exist' do
      result = CommentService.delete(999)

      expect(result[:ok]).to be false
      expect(result[:msg]).to eq('Comment not found')
    end
  end
end
