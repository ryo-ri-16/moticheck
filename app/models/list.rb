class List < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  belongs_to :list_template, optional: true
  has_many :list_items, dependent: :destroy
  has_many :items, through: :list_items
  has_many :notifications, dependent: :destroy

  before_validation :set_default_category

  validates :title, presence: true, length: { maximum: 100 }
  validates :status, presence: true
  validates :scheduled_at, presence: true
  validates :target_date, presence: true, if: -> { list_template_id.present? }

  # 優先度
  scope :normal_priority, -> { where(priority: false) }
  scope :high_priority, -> { where(priority: true) }
  scope :prioritize, -> { order(priority: :desc) }
  # 一覧ページの表示セクション
  scope :scheduled_today, -> {
    where(scheduled_at: Time.zone.today.all_day)
  }

  scope :near_future, -> {
    where(
      scheduled_at: Time.zone.tomorrow.beginning_of_day..
                    3.days.from_now.end_of_day
    )
  }
  scope :past_not_complete, -> {
    where("scheduled_at < ?", Time.zone.now)
      .where.not(status: :completed)
  }
  # 通知対象か
  scope :remind_target, -> {
    where(scheduled_at: 1.day.from_now.all_day)
    .where(reminded_at: nil)
  }
  scope :starting_now, -> {
    where(scheduled_at: 7.minutes.ago..Time.current)
    .where(started_notification_at: nil)
    .order(scheduled_at: :asc)
  }
  # ホーム画面のセクション
  scope :ordered_for_home, -> {
    order(
      Arel.sql("CASE WHEN status = #{statuses[:completed]} THEN 1 ELSE 0 END"),
      Arel.sql("CASE WHEN scheduled_at < CURRENT_DATE THEN 1 ELSE 0 END"),
      priority: :desc,
      scheduled_at: :asc,
      updated_at: :desc
    )
  }
  scope :scheduled_asc, -> { order(scheduled_at: :asc) }
  scope :incomplete, -> { where.not(status: :completed) }
  scope :checking, -> { where(status: :checking) }
  scope :complete, -> { where(status: :completed) }
  # フィルタ用
  scope :name_asc,  -> { order(title: :asc) }
  scope :name_desc, -> { order(title: :desc) }
  scope :updated_recent, -> { order(updated_at: :desc) }
  scope :updated_old, -> { order(updated_at: :asc) }
  scope :created_recent, -> { order(created_at: :desc) }
  scope :created_old, -> { order(created_at: :asc) }
  scope :used_recent, -> { order(last_used_at: :desc) }
  scope :used_old, -> { order(last_used_at: :asc) }
  scope :with_status, ->(status) {
    where(status: status)
  }

  enum :status, { waiting: 0, checking: 1, completed: 2 }

  def start_checking!
    return false unless waiting?
    update(status: :checking)
  end

  # waitingから完了できないようにしている
  def finish_checking!
    return false unless checking?
    return false unless can_completed?

    update(
      status: :completed,
      last_used_at: Time.current
    )
  end

  # アイテムのチェック状態を解除しながらチェック状態をキャンセルしている
  def back_to_waiting!
    return false unless checking?
    transaction do
      update!(status: :waiting)
      list_items.update_all(checked: false)
    end
  end

  def checked_items
    list_items.checked
  end

  def unchecked_items
    list_items.unchecked
  end

  def checked_count
    checked_items.count
  end

  def total_count
    list_items.count
  end

  def items_count
    list_items_count
  end

  # プログレスバー
  def progress_percentage
    return 0 if list_items.count.zero?

    checked = list_items.where(checked: true).count
    total   = list_items.count

    (checked.to_f / total * 100).round
  end

  # 全てのアイテムをチェックすると完了状態にできる
  def can_completed?
    list_items.where(checked: true).count == list_items.count
  end

  # カテゴリーがない場合は未分類として扱う
  def category_name
    category&.name || "未分類"
  end

  # アクションボタンを利用できるのはwaiting状態
  def locked?
    checking? || completed?
  end

  # 完了後のリストをコピーした際にアイテムはチェック解除
  def reset_items!
    if persisted?
      list_items.update_all(checked: false)
    else
      list_items.each { |li| li.checked = false }
    end
  end

  def build_reuse
    new_list = deep_clone include: :list_items
    # リストの状態をリセットしている
    new_list.status = :waiting
    new_list.last_used_at = nil
    new_list.list_items_count = 0
    new_list.list_template_id = nil
    new_list.target_date = nil

    new_list.target_date = Date.current
    new_list.scheduled_at = Time.current

    new_list.reset_items!

    new_list
  end

  private

  def set_default_category
    self.category ||= Category.find_or_create_by!(
      user: user, name: "未分類")
  end
end
