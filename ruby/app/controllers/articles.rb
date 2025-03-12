# frozen_string_literal: true

require_relative '../services/article_service'

# Controller for article operations following RESTful conventions
class ArticleController
  def index
    ArticleService.all
  end

  def show(id)
    ArticleService.find(id)
  end

  def create(params)
    ArticleService.create(params)
  end

  def update(id, params)
    ArticleService.update(id, params)
  end

  def destroy(id)
    ArticleService.delete(id)
  end

  alias get_article show
  alias get_batch index
  alias create_article create
  alias update_article update
  alias delete_article destroy
end
