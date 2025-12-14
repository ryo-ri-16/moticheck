class ListItem < ApplicationRecord
  belongs_to :list
  belongs_to :item

  validates :quantity, numericality: { greater_than: 0 }, allow_nil: true
  validates :position, presence: true
end
