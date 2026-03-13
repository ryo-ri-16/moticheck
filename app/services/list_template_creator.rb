class ListTemplateCreator
  def self.call(user:, list:)
    ActiveRecord::Base.transaction do
      template = user.list_templates.create!(
        title: list.title,
        category: list.category
      )

      list.list_items.order(:position).each do |item|
        template.list_template_items.create!(
          name: item.item.name
        )
      end
      template
    end
  end
end
