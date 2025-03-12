# frozen_string_literal: true

require 'rspec/autorun'
require_relative '../../config/environment'
require_relative '../../app/models/db_init'
require_relative '../../app/models/article'

describe Article do
  describe 'validations' do
    it 'is valid with valid attributes' do
      article = Article.new(title: 'Test Article', content: 'Test Content')
      expect(article).to be_valid
    end

    it 'is not valid without a title' do
      article = Article.new(content: 'Test Content')
      expect(article).not_to be_valid
    end

    it 'is not valid without content' do
      article = Article.new(title: 'Test Article')
      expect(article).not_to be_valid
    end

    it 'is not valid with a duplicate title' do
      Article.create(title: 'Unique Title', content: 'Test Content')
      article = Article.new(title: 'Unique Title', content: 'Different Content')
      expect(article).not_to be_valid
    end
  end

  describe 'associations' do
    it 'has many comments' do
      article = Article.create(title: 'Article with Comments', content: 'Test Content')
      comment1 = Comment.create(article_id: article.id, content: 'First comment', author_name: 'John')
      comment2 = Comment.create(article_id: article.id, content: 'Second comment', author_name: 'Jane')

      expect(article.comments.count).to eq(2)
      expect(article.comments).to include(comment1)
      expect(article.comments).to include(comment2)
    end

    it 'deletes associated comments when deleted' do
      article = Article.create(title: 'Article to Delete', content: 'Test Content')
      Comment.create(article_id: article.id, content: 'Comment to be deleted', author_name: 'John')

      expect { article.destroy }.to change { Comment.count }.by(-1)
    end
  end
end
