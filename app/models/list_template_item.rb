class ListTemplateItem < ApplicationRecord
  belongs_to :list_template
  acts_as_list scope: :list_template

  before_validation :normalize_name

  validates :name, presence: true
  validates :name, length: { maximum: 100 }
  validates :name, uniqueness: {
    scope: :list_template_id, case_sensitive: false
  }

  private

  def normalize_name
    self.name = name.strip if name.present?
  end
end
