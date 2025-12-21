class User < ApplicationRecord
  has_many :lists, dependent: :destroy
  has_many :categories, dependent: :destroy
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  after_create :create_default_category

  private

  def create_default_category
    categories.find_or_create_by!(name: "未分類")
  end
end
