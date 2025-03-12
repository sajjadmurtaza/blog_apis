# frozen_string_literal: true

require_relative 'comments/create'
require_relative 'comments/update'
require_relative 'comments/find'
require_relative 'comments/delete'
require_relative 'comments/index'

# Facade service for comment operations
class CommentService
  class << self
    def create(comment_params)
      Comments::Create.call(comment_params)
    end

    def update(id, comment_params)
      Comments::Update.call(id, comment_params)
    end

    def find(id)
      Comments::Find.call(id)
    end

    def delete(id)
      Comments::Delete.call(id)
    end


    def all(article_id = nil)
      Comments::Index.call(article_id)
    end

    alias destroy delete
    alias show find
    alias index all
  end
end
