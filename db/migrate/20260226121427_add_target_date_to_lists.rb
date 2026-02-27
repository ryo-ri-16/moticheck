class AddTargetDateToLists < ActiveRecord::Migration[8.0]
  def change
    add_column :lists, :target_date, :date
  end
end
