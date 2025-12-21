ApplicationRecord.transaction do
  Category.find_or_create_by!(name: "未分類")
end
