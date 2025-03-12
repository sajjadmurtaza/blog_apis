# frozen_string_literal: true

require_relative 'base'

module Articles
  # Service class responsible for updating existing articles
  class Update < Base
    def call(id, params)
      article = find_article(id)
      return article_not_found_error unless article

      if article.update(article_params(params))
        success_response(obj: article)
      else
        error_response(article.errors.full_messages.join(', '))
      end
    rescue StandardError => e
      error_response(e.message)
    end
  end
end
