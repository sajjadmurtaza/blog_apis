# frozen_string_literal: true

require 'active_record'
require 'logger'

# Initialize the database
ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: ENV['DB_NAME'],
  host: ENV['DB_HOST'],
  username: ENV['DB_USER'],
  password: ENV['DB_PASS']
)

# Set up logging for database operations
ActiveRecord::Base.logger = Logger.new($stdout)
ActiveRecord::Base.logger.level = Logger::INFO

# Load the Article model
require_relative 'article'

# Create the database schema
ActiveRecord::Base.connection.create_table(:articles, primary_key: 'id', force: true) do |t|
  t.string :title
  t.string :content
  t.string :created_at
end

# Seed the database with initial data
# First, delete all existing articles to avoid uniqueness constraint violations
Article.delete_all

# Then create the test articles
Article.create(title: 'Title ABC', content: 'Lorem Ipsum', created_at: Time.now)
Article.create(title: 'Title ZFX', content: 'Some Blog Post', created_at: Time.now)
Article.create(title: 'Title YNN', content: 'O_O_Y_O_O', created_at: Time.now)

puts "Article count in DB: #{Article.count}"
