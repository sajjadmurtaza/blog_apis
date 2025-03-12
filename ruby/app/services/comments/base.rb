# frozen_string_literal: true

module Comments
  # Base service class that provides common functionality for all comment services
  class Base
    def self.call(*args)
      new.call(*args)
    end

    private

    def find_comment(id)
      Comment.find_by(id:)
    end

    def find_article(article_id)
      Article.find_by(id: article_id)
    end

    def comment_exists?(id)
      Comment.exists?(id:)
    end

    def success_response(**data)
      { ok: true }.merge(data)
    end

    def error_response(message)
      { ok: false, msg: message }
    end

    def comment_not_found_error
      error_response('Comment not found')
    end

    def article_not_found_error
      error_response('Article not found')
    end

    def comment_params(params)
      result = {}
      result[:article_id] = params['article_id'] if params.key?('article_id')
      result[:content] = params['content'] if params.key?('content')
      result[:author_name] = params['author_name'] if params.key?('author_name')
      result[:created_at] = Time.now if params.key?('created_at') || !Comment.exists?(id: params['id'].to_i)
      result
    end
  end
end
