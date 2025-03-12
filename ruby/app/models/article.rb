# frozen_string_literal: true

# Article model representing blog posts in the database
class Article < ActiveRecord::Base
  self.table_name = 'articles'

  has_many :comments, dependent: :destroy

  validates :title, presence: true, uniqueness: true
  validates :content, presence: true
end
