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
  end
end
