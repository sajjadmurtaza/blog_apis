#!/usr/bin/env ruby
# frozen_string_literal: true

require 'irb'
require 'irb/completion'

# Load the application environment
require_relative 'config/environment'
require_relative 'app/models/db_init'

# Load all models, controllers, and services
require_relative 'app/models/article'
require_relative 'app/services/article_service'
require_relative 'app/controllers/articles'

# Print a welcome message
puts 'Welcome to the Ruby Blog API Console!'
puts 'Your application environment has been loaded.'
puts 'Available models: Article'
puts 'Available services: ArticleService'
puts 'Available controllers: ArticleController'
puts "\nExample usage:"
puts '  Article.all                  # Get all articles'
puts '  Article.find_by(id: 1)       # Get article with ID 1'
puts '  ArticleService.all           # Get all articles using the service'
puts '  ArticleService.find(1)       # Get article with ID 1 using the service'
puts '  controller = ArticleController.new'
puts '  controller.index             # Get all articles using the controller'
puts '  controller.with_params({id: 1}).show  # Get article with ID 1 using the controller'
puts '  # For backward compatibility:'
puts '  controller.get_batch         # Get all articles (alias for index)'
puts '  controller.with_params({id: 1}).get_article  # Get article with ID 1 (alias for show)'

# Start IRB session
IRB.start
