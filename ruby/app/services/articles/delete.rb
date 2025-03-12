# frozen_string_literal: true

require_relative 'base'

module Articles
  # Service class responsible for deleting articles
  class Delete < Base
    def call(id)
      article = find_article(id)
      return article_not_found_error unless article

      success_response(delete_count: delete_article(id))
    rescue StandardError => e
      error_response(e.message)
    end

    private

    def delete_article(id)
      Article.where(id:).delete_all
    end
  end
end
