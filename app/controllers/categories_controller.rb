class CategoriesController < ApplicationController
  before_action :set_category, only: [ :edit, :update, :destroy ]
  before_action :prevent_uncategorized_deletion, only: [ :destroy ]
  def index
    @categories = current_user.categories.created
    @category = current_user.categories.new
  end

  def create
    @category = current_user.categories.new(category_params)

    if @category.save
      redirect_to categories_path, notice: "カテゴリーを作成しました"
    else
      redirect_to categories_path, alert: @category.errors.full_messages.join(", ")
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to categories_path, notice: "更新しました" }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to categories_path, notice: "削除しました" }
    end
  end

  private

  def set_category
    @category = current_user.categories.find(params[:id])
  end

  def category_params
    params.require(:category).permit(
      :name
    )
  end

  def prevent_uncategorized_deletion
    if @category.uncategorized?
      redirect_to categories_path, alert: "「未分類」カテゴリーは削除できません"
    end
  end
end
