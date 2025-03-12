# frozen_string_literal: true

require_relative 'base'

module Articles
  # Service class responsible for creating new articles
  class Create < Base
    def call(params)
      return duplicate_title_error if title_exists?(params['title'])

      article = Article.new(article_params(params))
      return success_response(obj: article) if article.save

      error_response(article.errors.full_messages.join(', '))
    rescue StandardError => e
      error_response(e.message)
    end
  end
end
