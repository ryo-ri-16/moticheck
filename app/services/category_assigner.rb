class CategoryAssigner
  def self.call(list:, user:, category_name:)
    return if category_name.blank?

    name = category_name.strip
    return if name.blank?

    category = Category.find_or_create_by(
      user: user,
      name: name
    )

    list.category = category if category.persisted?
  end
end
