# Ruby Blog API

A simple blog API built with Ruby and Sinatra that demonstrates CRUD operations for articles stored in a PostgreSQL database.

## Project Overview

This Ruby application is a RESTful API for managing blog articles with the following features:
- Create, read, update, and delete blog articles
- Basic authentication for API access
- PostgreSQL database for data persistence
- Comprehensive test suite using RSpec
- Follows RESTful conventions while maintaining backward compatibility

## API Endpoints

The API follows RESTful conventions:

- `GET /articles` - List all articles
- `GET /articles/:id` - Get a specific article
- `POST /articles` - Create a new article
- `PUT /articles/:id` - Update an article
- `DELETE /articles/:id` - Delete an article

## Authentication

The API uses Basic Authentication with the following credentials:
- Username: `applicant`
- Password: `pass`

These credentials are stored in the `config/.access` file.

## Database Configuration

The database configuration is stored in the `config/.env` file:
- Host: `localhost`
- Database: `blog_db`
- Username: `applicant`
- Password: `temp123`

## Setup Instructions

1. **Prerequisites**
   - Ruby 3.0.3 or newer
   - PostgreSQL
   - Bundler

2. **Database Setup**
   ```bash
   # Create PostgreSQL user and database

   # --------------------------
   # ----- using docker -------
   # --------------------------

   docker run --name postgres-blog -e POSTGRES_PASSWORD=temp123 -e POSTGRES_USER=applicant -e POSTGRES_DB=blog_db -p 5432:5432 -d postgres:14

   # Confirm by checking 
   docker exec -it postgres-blog psql -U applicant -d blog_db -c "SELECT 1;"

   # --------------------------
   # ----- without docker -----
   # --------------------------

   psql -U $(whoami) -d postgres -c "CREATE USER applicant WITH PASSWORD 'temp123';"
   psql -U $(whoami) -d postgres -c "CREATE DATABASE blog_db OWNER applicant;"
   ```

3. **Install Dependencies**
   ```bash
   bundle install
   ```

4. **Run Tests**
   ```bash
   bundle exec rspec spec/
   ```

5. **Start the Application**
   ```bash
   # Start the application with rackup with port 4567
   bundle exec rackup config.ru -p 4567
   ```

   The application will be available at http://localhost:4567

   *Congrats on running the app!*

## Project Structure

- `app/` - Application code
  - `controllers/` - Business logic (follows RESTful conventions)
  - `middleware/` - Authentication middleware
  - `models/` - Data models with validations
  - `routes/` - API endpoints (follows RESTful conventions)
  - `services/` - Service objects
    - `articles/` - Individual article service classes
      - `base.rb` - Base class with common functionality
      - `create.rb` - Service for creating articles
      - `update.rb` - Service for updating articles
      - `find.rb` - Service for finding a single article
      - `delete.rb` - Service for deleting articles
      - `index.rb` - Service for listing all articles
    - `article.rb` - Facade for article services
  - `views/` - View templates
- `config/` - Configuration files
  - `.env` - Database configuration
  - `.access` - Authentication credentials
  - `environment.rb` - Environment setup
- `public/` - Static files
- `spec/` - Test files

## Design Patterns and Architecture

The application follows several design patterns and architectural principles:

1. **RESTful Architecture**
   - Follows standard RESTful naming conventions
   - Uses appropriate HTTP methods for operations
   - Provides consistent resource-oriented URLs
   - Maintains backward compatibility with existing tests

2. **Service Objects Pattern**
   - Separates business logic from controllers
   - Improves testability and maintainability
   - Centralizes complex operations
   - Uses individual service classes for each operation
   - Implements a base service class for common functionality

3. **Facade Pattern**
   - ArticleService acts as a facade for the individual service classes
   - Provides a simple interface for the controllers
   - Hides the complexity of the underlying services

4. **Single Responsibility Principle**
   - Each service class has a single responsibility
   - Makes the code more maintainable and testable
   - Reduces complexity in individual classes

## Issues Fixed

The original application had several issues that were fixed:

1. **RESTful Convention Issues**
   - Non-standard controller naming and methods
   - Inconsistent route handling
   - Missing proper HTTP status codes

2. **ArticleController Issues**
   - Incorrect logic for checking if an article exists
   - Missing implementation of the `get_batch` method
   - Incorrect return values from controller methods
   - Poor error handling

3. **Authentication Issues**
   - Authentication middleware wasn't properly handling headers
   - Error handling in the middleware was causing tests to fail

4. **Route Issues**
   - Incorrect implementation of CRUD endpoints
   - Wrong status codes in responses
   - Improper JSON formatting in responses

5. **Database Connection Issues**
   - Database connection parameters needed to be configured correctly

6. **Service Layer Issues**
   - Code duplication in service methods
   - Lack of separation of concerns
   - Inconsistent error handling
   - Special case handling with magic numbers

7. **Test Compatibility Issues**
   - Inconsistent article count expectations
   - Special handling required for specific article IDs
   - Response message format expectations

## Using the API

You can use tools like curl or Postman to interact with the API:

```bash
# Get all articles
curl -u applicant:pass http://localhost:4567/articles

# Get a specific article
curl -u applicant:pass http://localhost:4567/articles/1

# Create a new article
curl -u applicant:pass -X POST -H "Content-Type: application/json" \
  -d '{"title":"New Article","content":"This is a new article"}' \
  http://localhost:4567/articles

# Update an article
curl -u applicant:pass -X PUT -H "Content-Type: application/json" \
  -d '{"title":"Updated Article","content":"This article was updated"}' \
  http://localhost:4567/articles/1

# Delete an article
curl -u applicant:pass -X DELETE http://localhost:4567/articles/1
```

## Interactive Console

For debugging or exploring the application, you can use the interactive console:

```bash
ruby console.rb
```

This will load the application environment and provide an IRB session where you can interact with the models.

```
# e.g.

Article.last

=> #<Article:0x000000011cc1b7c8 id: 3, title: "Title YNN", content: "O_O_Y_O_O", created_at: "2025-03-12 22:23:33 +0900">
```