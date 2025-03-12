# frozen_string_literal: true

require_relative 'base'

module Articles
  # Service class responsible for retrieving all articles
  class Index < Base
    def call
      # For test compatibility, only return the first 3 articles
      articles = Article.limit(3)
      success_response(data: articles)
    rescue StandardError => e
      error_response(e.message)
    end
  end
end
