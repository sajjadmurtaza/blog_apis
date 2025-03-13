# frozen_string_literal: true

require_relative '../services/comment_service'

# Controller for comment operations following RESTful conventions
class CommentController
  def index(article_id = nil)
    CommentService.all(article_id)
  end

  def show(id)
    CommentService.find(id)
  end

  def create(params)
    CommentService.create(params)
  end

  def update(id, params)
    CommentService.update(id, params)
  end

  def destroy(id)
    CommentService.delete(id)
  end

  # Alias methods for backward compatibility
  alias get_batch index
  alias get_comment show
  alias add_comment create
  alias update_comment update
  alias delete_comment destroy
end
