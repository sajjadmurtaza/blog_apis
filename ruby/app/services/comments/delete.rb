# frozen_string_literal: true

require_relative 'base'

module Comments
  # Service class responsible for deleting comments
  class Delete < Base
    def call(id)
      comment = find_comment(id)
      return comment_not_found_error unless comment

      success_response(delete_count: delete_comment(id))
    rescue StandardError => e
      error_response(e.message)
    end

    private

    def delete_comment(id)
      Comment.where(id:).delete_all
    end
  end
end
