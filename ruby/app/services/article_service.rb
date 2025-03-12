# frozen_string_literal: true

require_relative 'articles/create'
require_relative 'articles/update'
require_relative 'articles/find'
require_relative 'articles/delete'
require_relative 'articles/index'

# Service object for article operations
class ArticleService
  class << self
    def create(article_params)
      Articles::Create.call(article_params)
    end

    def update(id, article_params)
      Articles::Update.call(id, article_params)
    end

    def find(id)
      Articles::Find.call(id)
    end

    def delete(id)
      Articles::Delete.call(id)
    end

    def all
      Articles::Index.call
    end
  end
end
