class ListTemplateItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list_template
  before_action :set_list_template_item, only: [ :edit, :update, :destroy ]

  def create
    @list_template_item =
      @list_template.list_template_items.build(list_template_item_params)

    if @list_template_item.save
      @template_items = @list_template.list_template_items.ordered

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @list_template }
      end
    else
      redirect_to @list_template, alert: "追加に失敗しました"
    end
  end

  def edit
  end

  def update
    if @list_template_item.update(list_template_item_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @list_template, notice: "更新しました" }
      end
    else
      redirect_to @list_template, alert: "更新に失敗しました"
    end
  end

  def destroy
    @list_template_item.destroy
    @list_template.reload

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @list_template }
    end
  end

  private

  def set_list_template
    @list_template =
      current_user.list_templates.user_created.find(params[:list_template_id])
  end

  def set_list_template_item
    @list_template_item =
      @list_template.list_template_items.find(params[:id])
  end

  def list_template_item_params
    params.require(:list_template_item).permit(:name, :position)
  end
end
