# Ruby Blog<>Article API

A simple Article API built with Ruby and Sinatra that demonstrates CRUD operations for articles stored in a PostgreSQL database.

## Project Overview

This Ruby application is a RESTful API for managing Article articles with the following features:
- Create, read, update, and delete Article articles
- Basic authentication for API access
- PostgreSQL database for data persistence
- Comprehensive test suite using RSpec

## API Endpoints

- `GET /articles` - Get all articles
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
  - `controllers/` - Business logic
  - `middleware/` - Authentication middleware
  - `models/` - Data models
  - `routes/` - API endpoints
  - `views/` - View templates
- `config/` - Configuration files
  - `.env` - Database configuration
  - `.access` - Authentication credentials
  - `environment.rb` - Environment setup
- `public/` - Static files
- `spec/` - Test files

## Issues Fixed

The original application had several issues that were fixed:

1. **ArticleController Issues**
   - Incorrect logic for checking if an article exists
   - Missing implementation of the `get_batch` method
   - Incorrect return values from controller methods
   - Poor error handling

2. **Authentication Issues**
   - Authentication middleware wasn't properly handling headers
   - Error handling in the middleware was causing tests to fail

3. **Route Issues**
   - Incorrect implementation of CRUD endpoints
   - Wrong status codes in responses
   - Improper JSON formatting in responses

4. **Database Connection Issues**
   - Database connection parameters needed to be configured correctly

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
