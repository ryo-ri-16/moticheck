class ListGenerator
  def self.run(date = Date.current)
    ListTemplate.find_each do |template|
      next unless should_generate?(template, date)

      create_list_from(template, date)
    end
  end

  def self.should_generate?(template, date)
    case template.repeat_type
    when "none"
      false
    when "daily"
      true
    when "weekly"
      weekday_symbol = Date::DAYNAMES[date.wday].downcase.to_sym
      template.weekdays.include?(weekday_symbol)
    else
      false
    end
  end

  def self.create_list_from(template, date)
    return if template.lists.exists?(target_date: date)

    list = List.create!(
      user: template.user,
      title: template.title,
      category: template.category,
      list_template: template,
      target_date: date,
      scheduled_at: today.in_time_zone.change(hour: 8)
    )

    template.list_template_items.each do |template_item|
      item = Item.find_or_create_by!(name: template_item.name)

      list.list_items.create!(
        item: item
      )
    end
  end
end
