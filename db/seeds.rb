ApplicationRecord.transaction do
  user = User.find_or_create_by!(email: "demo@example.com") do |u|
    u.password = "password"
  end

  uncategorized = Category.find_or_create_by!(name: "未分類", user_id: nil)

    templates_data = [
    {
      title: "外出の準備",
      category: uncategorized,
      items: [ "鍵", "財布", "スマホ", "ハンカチ・ティッシュ" ]
    },
    {
      title: "旅行の持ち物",
      category: uncategorized,
      items: [ "着替え", "充電器", "常備薬", "身分証明書", "旅行保険" ]
    },
    {
      title: "出勤前のチェック",
      category: uncategorized,
      items: [ "PC", "社員証", "名刺", "資料", "筆記用具" ]
    },
    {
      title: "買い物リスト",
      category: uncategorized,
      items: [ "飲み物", "肉", "卵", "米・パン", "野菜" ]
    }
  ]

  templates_data.each do |data|
    template = ListTemplate.create!(
      title: data[:title],
      category: data[:category],
      user_id: nil,
      is_initial: true
    )

    data[:items].each.with_index(1) do |item_name, position|
      template.list_template_items.create!(
        name: item_name,
        position: position
      )
    end
  end
end
