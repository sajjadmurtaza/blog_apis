# frozen_string_literal: true

require_relative 'base'

module Comments
  # Service class responsible for creating new comments
  class Create < Base
    def call(params)
      article = find_article(params['article_id'])
      return article_not_found_error unless article

      comment = Comment.new(comment_params(params))
      return success_response(obj: comment) if comment.save

      error_response(comment.errors.full_messages.join(', '))
    rescue StandardError => e
      error_response(e.message)
    end
  end
end
