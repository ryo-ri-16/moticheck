ApplicationRecord.transaction do
  ListItem.delete_all
  List.delete_all
  Item.delete_all
  User.delete_all
end
