class ListItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list
  before_action :set_list_item, only: [ :update, :destroy, :check_switching ]

  def new
    @list_item = @list.list_items.build
  end

  def create
    item_name = list_item_params[:item_name]&.strip

    if item_name.blank?
      redirect_to @list, alert: "アイテム名を入力してください"
      return
    end

    item = Item.find_or_create_by(name: item_name)

    @list_item = @list.list_items.build(
      item: item,
      quantity: list_item_params[:quantity].presence || 1,
      checked: false,
    )

    if @list_item.save
      redirect_to @list, notice: "アイテムを追加しました"
    else
      redirect_to @list, alert: "追加に失敗しました"
    end
  end

  def update
    if list_item_update_params[:item_name].present?
      item = Item.find_or_create_by(
        name: list_item_update_params[:item_name].strip
      )
      @list_item.item = item
    end

    if list_item_update_params[:quantity].present?
      @list_item.quantity = list_item_update_params[:quantity]
    end

    if @list_item.save
      redirect_to @list, notice: "アイテムを更新しました"
    else
      redirect_to @list, alert: "更新に失敗しました"
    end
  end

  def destroy
    @list_item.destroy
    redirect_to @list, notice: "アイテムを削除しました"
  end

  def check_switching
    @list_item.update(checked: !@list_item.checked)
    redirect_to @list, notice: "チェック状態を更新しました"
  end

  private

  def set_list
    @list = current_user.lists.find(params[:list_id])
  end

  def set_list_item
    @list_item = @list.list_items.find(params[:id])
  end

  def list_item_params
    params.require(:list_item).permit(:item_name, :quantity)
  end

  def list_item_update_params
    params.require(:list_item).permit(:item_name, :quantity, :checked)
  end
end
