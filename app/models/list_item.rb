class ListItem < ApplicationRecord
  before_validation :set_position, on: :create
  belongs_to :list, counter_cache: true
  belongs_to :item

  attr_accessor :item_name

  validates :item_id, uniqueness: { scope: :list_id }
  validates :quantity, numericality: { greater_than: 0 }, allow_nil: true
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :list_must_be_editable, on: :create

  scope :checked, -> { where(checked: true) }
  scope :unchecked, -> { where(checked: false) }

  def set_position
    return if position.present?
    return unless list

    max_position = list.list_items.maximum(:position) || 0
    self.position = max_position + 1
  end

  def list_must_be_editable
    if list.locked?
      errors.add(:base, "チェック中または完了中は追加できません")
    end
  end
end
