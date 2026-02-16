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
      @list_item = @list.list_items.build(list_item_params)
      @list_item.errors.add(:item_name, "を入力してください")

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("item_form",
            partial: "lists/show/item_add",
            locals: { list: @list, list_item: @list_item }
          )
        end
        format.html { redirect_to @list, alert: "アイテム名を入力してください" }
      end
      return
    end

    item = Item.find_or_create_by(name: item_name)

    @list_item = @list.list_items.build(
      item: item,
      quantity: list_item_params[:quantity].presence || 1,
      checked: false
    )

    if @list_item.save
      Rails.logger.debug "=== 保存後のアイテム数: #{@list.list_items.count}"
      Rails.logger.debug "=== リロード後のアイテム数: #{@list.list_items.reload.count}"
      @list_items = @list.list_items.includes(:item).reload
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @list }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("item_form",
            partial: "lists/show/item_add",
            locals: { list: @list, list_item: @list_item }
          )
        end
        format.html { redirect_to @list, alert: "追加に失敗しました" }
      end
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
    @list_items = @list.list_items.includes(:item)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @list, notice: "アイテムを削除しました" }
    end
  end

  def check_switching
    @list_item.update(checked: !@list_item.checked)
    @list_items = @list.list_items.includes(:item)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @list, notice: "チェック状態を更新しました" }
    end
  end

  private

  def set_list
    @list = current_user.lists.find(params[:list_id])
  end

  def set_list_item
    @list_item = @list.list_items.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to list_path(@list),
                alert: "このアイテムは既に削除されています"
    return # rubocop:disable Style/RedundantReturn
  end

  def list_item_params
    params.require(:list_item).permit(:item_name, :quantity)
  end

  def list_item_update_params
    params.require(:list_item).permit(:item_name, :quantity, :checked)
  end
end
