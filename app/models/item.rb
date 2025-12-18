class Item < ApplicationRecord
  has_many :list_items, dependent: :destroy
  has_many :lists, through: :list_items

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :name, length: { maximum: 100 }

  before_validation :normalize_name

  private

  def normalize_name
    self.name = name.strip if name.present?
  end
end
