class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :list

  enum :kind, {
    reminder: 0,
    start: 1
  }

  validates :kind, presence: true

  validates :list_id, uniqueness: { scope: [ :user_id, :kind ], message: "この通知は既に存在します" }

  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where.not(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }
  scope :for_user, ->(user) { where(user: user) }

  def mark_as_read!
    update!(read_at: Time.current)
  end

  def unread?
    read_at.nil?
  end
end
