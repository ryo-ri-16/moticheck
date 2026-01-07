class AddInitialListTemplates < ActiveRecord::Migration[8.0]
  def up
    templates_data = [
      {
        title: "外出の準備",
        items: [ "鍵", "財布", "スマホ", "ハンカチ・ティッシュ" ]
      },
      {
        title: "旅行の持ち物",
        items: [ "着替え", "充電器", "常備薬", "身分証明書", "旅行保険" ]
      },
      {
        title: "出勤前のチェック",
        items: [ "PC", "社員証", "名刺", "資料", "筆記用具" ]
      },
      {
        title: "買い物リスト",
        items: [ "飲み物", "肉", "卵", "米・パン", "野菜" ]
      }
    ]

    templates_data.each do |data|
      template = ListTemplate.find_or_create_by!(
        title: data[:title],
        user_id: nil,
        is_initial: true
      )

      data[:items].each.with_index(1) do |item_name, position|
        template.list_template_items.find_or_create_by!(
          name: item_name,
          position: position
        )
      end
    end
  end

  def down
    ListTemplate.where(user_id: nil, is_initial: true).find_each do |template|
      template.destroy
    end
  end
end
