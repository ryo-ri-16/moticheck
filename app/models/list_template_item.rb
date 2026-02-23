class ListTemplateItem < ApplicationRecord
  belongs_to :list_template, counter_cache: true

  acts_as_list scope: :list_template

  before_validation :set_position, on: :create

  before_validation :normalize_name

  validates :name, presence: true
  validates :name, length: { maximum: 100 }
  validates :name, uniqueness: {
    scope: :list_template_id, case_sensitive: false
  }
  scope :ordered, -> { order(:position) }

  private

  def normalize_name
    self.name = name.strip if name.present?
  end

  def set_position
    return if position.present?
    return unless list_template

    max_position = list_template.list_template_items.maximum(:position) || 0
    self.position = max_position + 1
  end
end
