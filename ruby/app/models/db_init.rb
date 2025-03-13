# frozen_string_literal: true

require 'active_record'
require 'logger'

# Initialize the database
ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: ENV.fetch('DB_NAME', nil),
  host: ENV.fetch('DB_HOST', nil),
  username: ENV.fetch('DB_USER', nil),
  password: ENV.fetch('DB_PASS', nil)
)

# Set up logging for database operations
ActiveRecord::Base.logger = Logger.new($stdout)
ActiveRecord::Base.logger.level = Logger::INFO

# Load the models
require_relative 'article'
require_relative 'comment'

# Create the articles table
ActiveRecord::Base.connection.create_table(:articles, primary_key: 'id', force: true) do |t|
  t.string :title
  t.string :content
  t.string :created_at
end

# Create the comments table
ActiveRecord::Base.connection.create_table(:comments, primary_key: 'id', force: true) do |t|
  t.integer :article_id
  t.text :content
  t.string :author_name
  t.datetime :created_at
  t.index :article_id
end

# Seed the database with initial data
# First, delete all existing articles to avoid uniqueness constraint violations
Article.delete_all

# Then create the test articles
Article.create(title: 'Title ABC', content: 'Lorem Ipsum', created_at: Time.now)
Article.create(title: 'Title ZFX', content: 'Some Blog Post', created_at: Time.now)
Article.create(title: 'Title YNN', content: 'O_O_Y_O_O', created_at: Time.now)

puts "Article count in DB: #{Article.count}"

# Add some sample comments
Comment.delete_all
first_article = Article.first
if first_article
  Comment.create(
    article_id: first_article.id,
    content: 'Great article!',
    author_name: 'John Doe',
    created_at: Time.now
  )
  Comment.create(
    article_id: first_article.id,
    content: 'I learned a lot from this.',
    author_name: 'Jane Smith',
    created_at: Time.now
  )
end

puts "Comment count in DB: #{Comment.count}"
