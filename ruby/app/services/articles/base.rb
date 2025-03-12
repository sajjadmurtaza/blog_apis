# frozen_string_literal: true

module Articles
  # Base service class that provides common functionality for all article services
  class Base
    def self.call(*args)
      new.call(*args)
    end

    private

    def find_article(id)
      Article.find_by(id:)
    end

    def article_exists?(id)
      Article.exists?(id:)
    end

    def title_exists?(title)
      Article.exists?(title:)
    end

    def success_response(**data)
      { ok: true }.merge(data)
    end

    def error_response(message)
      { ok: false, msg: message }
    end

    def article_not_found_error
      error_response('Article not found')
    end

    def duplicate_title_error
      error_response('Article with given title already exists')
    end

    def article_params(params)
      {
        title: params['title'],
        content: params['content']
      }
    end
  end
end
