# frozen_string_literal: true

require_relative 'base'

module Comments
  # Service class responsible for finding a specific comment by ID
  class Find < Base
    def call(id)
      comment = find_comment(id)
      return success_response(data: comment) if comment

      comment_not_found_error
    rescue StandardError => e
      error_response(e.message)
    end
  end
end
