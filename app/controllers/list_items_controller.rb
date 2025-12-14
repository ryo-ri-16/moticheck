class ListItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list
  before_action :set_list_item, only: [ :update, :destroy ]

  def new
    @list_item = @list.list_items.build
  end

  def create
    item = Item.find_or_create_by(name: list_item_params[:item_name])

    @list_item = @list.list_items.build(
      item: item,
      quantity: list_item_params[:quantity] || 1,
      checked: false,
      position: @list.list_items.count + 1
    )

    if @list_item.save
      redirect_to @list, notice: "アイテムを追加しました"
    else
      redirect_to @list, alert: "追加に失敗しました"
    end
  end

  def update
    if @list_item.update(list_item_update_params)
      redirect_to @list, notice: "アイテムを更新しました"
    else
      redirect_to @list, alert: "更新に失敗しました"
    end
  end

  def destroy
    @list_item.destroy
    redirect_to @list, notice: "アイテムを削除しました"
  end

  private

  def set_list
    @list = current_user.lists.find(params[:list_id])
  end

  def set_list_item
    @list_item = @list.list_items.find(params[:id])
  end

  def list_item_params
    params.require(:list_item).permit(:item_name, :quantity, :note)
  end

  def list_item_update_params
    params.require(:list_item).permit(:quantity, :checked, :position)
  end
end
