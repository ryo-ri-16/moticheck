class ListItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list
  before_action :set_list_item, only: [ :edit, :update, :destroy, :check_switching ]

  def show
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @list }
    end
  end

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

  def edit
    @list_item.item_name = @list_item.item.name
  end

  def update
    if list_item_update_params[:item_name].present?
      item = Item.find_or_create_by(
        name: list_item_update_params[:item_name].strip
      )
      @list_item.item = item
    end

    @list_item.quantity = list_item_update_params[:quantity]

    if @list_item.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @list, notice: "アイテムを更新しました" }
      end
    else
      redirect_to @list, alert: "更新に失敗しました"
    end
  end

  def destroy
    @list_item.destroy
    @list_items = @list.list_items.includes(:item)
    @list.reload

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @list, notice: "アイテムを削除しました" }
    end
  end

  # アイテムをチェック
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

  # 作成時と更新時でパラメーターを分けている
  def list_item_params
    params.require(:list_item).permit(:item_name, :quantity)
  end

  def list_item_update_params
    params.require(:list_item).permit(:item_name, :quantity, :checked)
  end
end
