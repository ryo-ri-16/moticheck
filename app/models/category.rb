class Category < ApplicationRecord
  belongs_to :user, optional: true
  has_many :lists, dependent: :nullify

  validates :name, presence: true,
                    uniqueness: { case_sensitive: false, scope: :user_id  },
                    length: { maximum: 50 }

  scope :ordered, -> { order(:name) }
  scope :for_user, ->(user) {
    where(user_id: user.id)
      .or(where(user_id: nil).where.not(name: "未分類"))
  }
end
