# frozen_string_literal: true

require_relative 'base'

module Comments
  # Service class responsible for updating existing comments
  class Update < Base
    def call(id, params)
      comment = find_comment(id)
      return comment_not_found_error unless comment

      if params['article_id'] && params['article_id'].to_i != comment.article_id
        article = find_article(params['article_id'])
        return article_not_found_error unless article
      end

      if comment.update(comment_params(params))
        success_response(obj: comment)
      else
        error_response(comment.errors.full_messages.join(', '))
      end
    rescue StandardError => e
      error_response(e.message)
    end
  end
end
