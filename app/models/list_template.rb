class ListTemplate < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :category, optional: true
  has_many :list_template_items, dependent: :destroy

  validates :title, uniqueness: { scope: :user_id }, presence: true, length: { maximum: 100 }

  scope :initial, -> { where(is_initial: true) }
  scope :user_created, -> { where(is_initial: false) }
  scope :global, -> { where(user_id: nil, is_initial: true) }
  scope :for_user, ->(user) {
    where(user_id: user.id).or(where(user_id: nil))
  }
  scope :for_user_custom, ->(user) {
    where(is_initial: false, user_id: user.id)
  }
end
