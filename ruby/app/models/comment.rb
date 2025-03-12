# frozen_string_literal: true

# Comment model representing user comments on blog articles
class Comment < ActiveRecord::Base
  self.table_name = 'comments'

  belongs_to :article

  validates :content, presence: true
  validates :article_id, presence: true
  validates :author_name, presence: true
end
