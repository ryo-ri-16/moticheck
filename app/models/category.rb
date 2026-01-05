class Category < ApplicationRecord
  UNCATEGORIZED_NAME = "未分類"
  belongs_to :user, optional: true
  has_many :lists, dependent: :nullify

  validates :name, presence: true,
                    uniqueness: { case_sensitive: false, scope: :user_id  },
                    length: { maximum: 50 }

  scope :ordered, -> { order(:name) }
  scope :created, -> { order(:created_at) }
  scope :for_user, ->(user) {
    where(user_id: user.id)
      .or(where(user_id: nil).where.not(name: "未分類"))
  }

  def uncategorized?
    name == UNCATEGORIZED_NAME
  end
end
