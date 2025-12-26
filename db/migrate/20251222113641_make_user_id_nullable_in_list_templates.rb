class MakeUserIdNullableInListTemplates < ActiveRecord::Migration[8.0]
  def change
    change_column_null :list_templates, :user_id, true
  end
end
