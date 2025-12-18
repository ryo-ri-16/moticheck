class List < ApplicationRecord
  belongs_to :user
  has_many :list_items, dependent: :destroy
  has_many :items, through: :list_items

  validates :title, presence: true, length: { maximum: 100 }
  validates :status, presence: true
  validates :scheduled_on, presence: true

  # 優先度
  scope :normal_priority, -> { where(priority: false) }
  scope :high_priority, -> { where(priority: true) }
  # 一覧表示用
  scope :scheduled_today, -> { where(scheduled_on: Date.current) }
  scope :incomplete, -> { where.not(status: :completed) }
  scope :checking, -> { where(status: :checking) }
  scope :complete, -> { where(status: :completed) }
  # フィルタ用
  scope :name_asc,  -> { order(title: :asc) }
  scope :name_desc, -> { order(title: :desc) }
  scope :updated_recent, -> { order(updated_at: :desc) }
  scope :updated_old, -> { order(updated_at: :asc) }
  scope :used_recent, -> { order(last_used_at: :desc) }
  scope :used_old, -> { order(last_used_at: :asc) }
  scope :with_status, ->(status) {
    where(status: status)
  }

  enum :status, { waiting: 0, checking: 1, completed: 2 }

  def start_checking!
    update(status: :checking)
  end

  def finish_checking!
    update(status: :completed)
  end

  def back_to_waiting!
    transaction do
      update!(status: :waiting)
      list_items.update_all(checked: false)
    end
  end

  def items_count
    list_items.count
  end

  def checked_items
    list_items.checked
  end

  def checked_count
    checked_items.count
  end
end
