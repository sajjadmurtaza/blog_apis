# frozen_string_literal: true

require_relative 'base'

module Comments
  # Service class responsible for retrieving all comments for an article
  class Index < Base
    def call(article_id = nil)
      if article_id
        article = find_article(article_id)
        return article_not_found_error unless article

        comments = Comment.where(article_id:)
      else
        comments = Comment.all
      end

      success_response(data: comments)
    rescue StandardError => e
      error_response(e.message)
    end
  end
end
