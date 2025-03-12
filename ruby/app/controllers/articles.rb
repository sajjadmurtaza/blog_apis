# frozen_string_literal: true

class ArticleController
  def create_article(article)
    article_exists = !Article.where(title: article['title']).empty?

    return { ok: false, msg: 'Article with given title already exists' } if article_exists

    new_article = Article.new(title: article['title'], content: article['content'], created_at: Time.now)
    new_article.save

    { ok: true, obj: new_article }
  rescue StandardError => e
    { ok: false, msg: e.message }
  end

  def update_article(id, new_data)
    article = Article.where(id: id).first

    return { ok: false, msg: 'Article could not be found' } if article.nil?

    article.title = new_data['title']
    article.content = new_data['content']
    article.save

    { ok: true, obj: article }
  rescue StandardError => e
    { ok: false, msg: e.message }
  end

  def get_article(id)
    article = Article.where(id: id).first

    if article
      { ok: true, data: article }
    else
      { ok: false, msg: 'Article not found' }
    end
  rescue StandardError => e
    { ok: false, msg: e.message }
  end

  def delete_article(id)
    article = Article.where(id: id).first

    return { ok: false, msg: 'Article not found' } if article.nil?

    delete_count = Article.where(id: id).delete_all

    { ok: true, delete_count: delete_count }
  rescue StandardError => e
    { ok: false, msg: e.message }
  end

  def get_batch
    articles = Article.all
    { ok: true, data: articles }
  rescue StandardError => e
    { ok: false, msg: e.message }
  end
end
