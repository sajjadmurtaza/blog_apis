# frozen_string_literal: true

class ArticleController
  def create_article(article)
    return { ok: false, msg: 'Article with given title already exists' } if article_exists?(article['title'])

    article = Article.new(title: article['title'], content: article['content'], created_at: Time.now)

    { ok: true, obj: article } if article.save
  rescue StandardError => e
    { ok: false, msg: e.message }
  end

  def update_article(id, new_data)
    article = find_article(id)
    return { ok: false, msg: 'Article not found' } unless article

    article.update(new_data)

    { ok: true, obj: article }
  rescue StandardError => e
    { ok: false, msg: e.message }
  end

  def get_article(id)
    article = find_article(id)
    return { ok: false, msg: 'Article not found' } unless article

    { ok: true, data: article }
  rescue StandardError => e
    { ok: false, msg: e.message }
  end

  def delete_article(id)
    article = find_article(id)
    return { ok: false, msg: 'Article not found' } unless article

    { ok: true, delete_count: 1 } if article.destroy
  rescue StandardError => e
    { ok: false, msg: e.message }
  end

  def get_batch
    articles = Article.all
    { ok: true, data: articles }
  rescue StandardError => e
    { ok: false, msg: e.message }
  end

  private

  def find_article(id)
    Article.find_by(id: id)
  end

  def article_exists?(title)
    Article.where(title: title).exists?
  end
end
