class CleanupGuestUsersJob < ApplicationJob
  queue_as :default

  # ゲストユーザーを削除している
  def perform
    deleted_count = 0
    error_count = 0

    User.expired_guests.find_each do |user|
      begin
        Rails.logger.info "Deleting expired guest user: ID=#{user.id}, created_at=#{user.guest_created_at}"

        user.destroy!
        deleted_count += 1
      rescue => e
        Rails.logger.error "Failed to delete guest user ID=#{user.id}: #{e.message}"
        error_count += 1
      end
    end

    Rails.logger.info "Guest cleanup completed: #{deleted_count} deleted, #{error_count} errors"
  end
end
