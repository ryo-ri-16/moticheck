class RecalculateListTemplateItemsCount < ActiveRecord::Migration[8.0]
  def up
    ListTemplate.find_each do |template|
      ListTemplate.reset_counters(template.id, :list_template_items)
    end
  end
end
