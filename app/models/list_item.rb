class ListItem < ApplicationRecord
  before_validation :set_position, on: :create

  belongs_to :list
  belongs_to :item

  validates :item_id, uniqueness: { scope: :list_id }
  validates :quantity, numericality: { greater_than: 0 }, allow_nil: true
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :checked, -> { where(checked: true) }
  scope :unchecked, -> { where(checked: false) }

  def set_position
    return if position.present?
    return unless list

    max_position = list.list_items.maximum(:position) || 0
    self.position = max_position + 1
  end
end
