class Category < ApplicationRecord
  belongs_to :user
  has_many :lists, dependent: :nullify

  validates :name, presence: true,
                    uniqueness: { case_sensitive: false, scope: :user_id  },
                    length: { maximum: 50 }

  scope :ordered, -> { order(:name) }
end
