# frozen_string_literal: true

require 'rspec/autorun'
require 'securerandom'
require_relative '../../config/environment'
require_relative '../../app/models/db_init'
require_relative '../../app/services/article_service'

describe ArticleService do
  describe '.all' do
    it 'returns all articles' do
      result = ArticleService.all
      expect(result[:ok]).to be true
      expect(result[:data]).to respond_to(:each)
      expect(result[:data].length).to be >= 3
    end
  end

  describe '.find' do
    it 'returns an article when it exists' do
      # Find the first article in the database
      first_article = Article.first
      result = ArticleService.find(first_article.id)

      expect(result[:ok]).to be true
      expect(result[:data]).to be_a(Article)
      expect(result[:data].id).to eq(first_article.id)
    end

    it 'returns an error when article does not exist' do
      result = ArticleService.find(999)
      expect(result[:ok]).to be false
      expect(result[:msg]).to eq('Article not found')
    end
  end

  describe '.create' do
    it 'creates a new article with valid parameters' do
      params = { 'title' => "New Test Article #{SecureRandom.hex(8)}", 'content' => 'This is a test article' }
      result = ArticleService.create(params)

      expect(result[:ok]).to be true
      expect(result[:obj]).to be_a(Article)
      expect(result[:obj].title).to eq(params['title'])
      expect(result[:obj].content).to eq('This is a test article')
    end

    it 'returns an error with invalid parameters' do
      params = { 'title' => '', 'content' => 'Missing title' }
      result = ArticleService.create(params)

      expect(result[:ok]).to be false
      expect(result[:msg]).to include("Title can't be blank")
    end

    it 'returns an error when title already exists' do
      existing_article = Article.first
      params = { 'title' => existing_article.title, 'content' => 'Duplicate title' }
      result = ArticleService.create(params)

      expect(result[:ok]).to be false
      expect(result[:msg]).to eq('Article with given title already exists')
    end
  end

  describe '.update' do
    it 'updates an article when it exists' do
      # Create a new article with a unique title
      unique_title = "Article to Update #{SecureRandom.hex(8)}"
      article = Article.create!(title: unique_title, content: 'Original content')
      params = { 'content' => 'Updated content' }

      result = ArticleService.update(article.id, params)

      expect(result[:ok]).to be true
      expect(result[:obj]).to be_a(Article)
      expect(result[:obj].content).to eq('Updated content')
    end

    it 'returns an error when article does not exist' do
      params = { 'content' => 'Updated content' }
      result = ArticleService.update(999, params)

      expect(result[:ok]).to be false
      expect(result[:msg]).to eq('Article not found')
    end
  end

  describe '.delete' do
    it 'deletes an article when it exists' do
      # Create a new article with a unique title
      unique_title = "Article to Delete #{SecureRandom.hex(8)}"
      article = Article.create!(title: unique_title, content: 'Content to delete')

      result = ArticleService.delete(article.id)

      expect(result[:ok]).to be true
      expect(result[:delete_count]).to eq(1)
      expect(Article.find_by(id: article.id)).to be_nil
    end

    it 'returns an error when article does not exist' do
      result = ArticleService.delete(999)

      expect(result[:ok]).to be false
      expect(result[:msg]).to eq('Article not found')
    end
  end
end
