class ListTemplate < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :category, optional: true
  has_many :list_template_items, dependent: :destroy
  has_many :lists, dependent: :destroy

  before_validation :assign_repeat_days_from_weekdays

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 500 }, allow_blank: true

  scope :initial, -> { where(is_initial: true) }
  scope :user_created, -> { where(is_initial: false) }
  scope :global, -> { where(user_id: nil, is_initial: true) }
  scope :for_user, ->(user) {
    where(user_id: user.id).or(where(user_id: nil))
  }
  scope :for_user_custom, ->(user) {
    where(is_initial: false, user_id: user.id)
  }
  scope :ordered, -> { order(created_at: :desc) }

  enum :repeat_type, {
    no_repeat: 0, daily: 1, weekly: 2
  }

  WEEKDAY_BITS = {
    sunday: 1,
    monday: 2,
    tuesday: 4,
    wednesday: 8,
    thursday: 16,
    friday: 32,
    saturday: 64
  }.freeze

  WEEKDAY_NAMES = {
    sunday: "日",
    monday: "月",
    tuesday: "火",
    wednesday: "水",
    thursday: "木",
    friday: "金",
    saturday: "土"
  }.freeze

  validates :repeat_days, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 127
  }

  def weekdays
    return [] if repeat_days.blank? || repeat_days.zero?

    WEEKDAY_BITS.keys.select do |day|
      (repeat_days & WEEKDAY_BITS[day]).positive?
    end
  end

  def weekdays=(days)
    days = Array(days).reject(&:blank?)
    self.repeat_days = days.sum { |day| WEEKDAY_BITS[day.to_sym] }
  end

  def weekday_labels
    weekdays.map { |day| WEEKDAY_NAMES[day] }
  end

  def everyday?
    self.daily?
  end

  def schedule_labels
    case repeat_type
    when "daily"
      [ "毎日" ]
    when "weekly"
      weekday_labels
    else
      []
    end
  end

  def items_count
    list_template_items_count
  end

  def assign_repeat_days_from_weekdays
    return if weekdays.blank?
    self.repeat_days = weekdays.sum { |day| WEEKDAY_BITS[day] }
  end
end
