# frozen_string_literal: true

require 'rspec/autorun'
require 'securerandom'
require_relative '../../config/environment'
require_relative '../../app/models/db_init'
require_relative '../../app/models/comment'

describe Comment do
  # Create a unique article for each test
  let(:article) do
    # Use a random string to ensure uniqueness
    random_suffix = SecureRandom.hex(8)
    Article.create!(title: "Test Article #{random_suffix}", content: 'Test Content')
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      comment = Comment.new(article_id: article.id, content: 'Test Comment', author_name: 'John Doe')
      expect(comment).to be_valid
    end

    it 'is not valid without content' do
      comment = Comment.new(article_id: article.id, author_name: 'John Doe')
      expect(comment).not_to be_valid
    end

    it 'is not valid without an article_id' do
      comment = Comment.new(content: 'Test Comment', author_name: 'John Doe')
      expect(comment).not_to be_valid
    end

    it 'is not valid without an author_name' do
      comment = Comment.new(article_id: article.id, content: 'Test Comment')
      expect(comment).not_to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to an article' do
      comment = Comment.create!(article_id: article.id, content: 'Test Comment', author_name: 'John Doe')
      expect(comment.article).to eq(article)
    end
  end

  describe 'database operations' do
    it 'can be created with valid attributes' do
      expect do
        Comment.create!(article_id: article.id, content: 'New Comment', author_name: 'Jane Smith')
      end.to change { Comment.count }.by(1)
    end

    it 'can be updated' do
      comment = Comment.create!(article_id: article.id, content: 'Original Content', author_name: 'John Doe')
      comment.update!(content: 'Updated Content')
      comment.reload
      expect(comment.content).to eq('Updated Content')
    end

    it 'can be deleted' do
      comment = Comment.create!(article_id: article.id, content: 'Comment to Delete', author_name: 'John Doe')
      expect do
        comment.destroy
      end.to change { Comment.count }.by(-1)
    end
  end
end
