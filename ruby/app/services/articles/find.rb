# frozen_string_literal: true

require_relative 'base'

module Articles
  # Service class responsible for finding a specific article by ID
  class Find < Base
    def call(id)
      article = find_article(id)
      return success_response(data: article) if article

      article_not_found_error
    rescue StandardError => e
      error_response(e.message)
    end
  end
end
