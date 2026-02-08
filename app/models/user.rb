class User < ApplicationRecord
  has_many :lists, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :list_templates, dependent: :destroy
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  after_create :create_default_category

  scope :guests, -> { where(guest: true) }
  scope :expired_guests, -> {
    guests.where("guest_created_at < ?", 14.days.ago)
  }

  def can_create_more_lists?
    return true unless guest?
    lists.count < 8
  end

  def can_copy?
    !guest?
  end

  def convert_to_registration!(name:, email:, password:, password_confirmation:)
    return false unless guest?

    transaction do
      update!(
        name: name,
        email: email,
        password: password,
        password_confirmation: password_confirmation,
        guest: false,
        guest_created_at: nil
      )
    end
  end

  GUEST_LIST_LIMIT = 8

  private

  def create_default_category
    categories.find_or_create_by!(name: "未分類")
  end
end
