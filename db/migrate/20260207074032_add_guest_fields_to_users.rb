class AddGuestFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :guest_created_at, :datetime

    add_index :users, :guest
    add_index :users, :guest_created_at
    add_index :users, [ :guest, :guest_created_at ]
  end
end
