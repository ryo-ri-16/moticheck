class CategoriesController < ApplicationController
  before_action :set_category, only: [ :destroy ]
  before_action :prevent_uncategorized_deletion, only: [ :destroy ]
  def index
    @categories = current_user.categories.created
  end

  def destroy
    if category.destroy
      redirect_to categories_path, notice: "カテゴリーを削除しました"
    else
      redirect_to categories_path, alert: "カテゴリーの削除に失敗しました"
    end
  end

  private

  def set_category
    @category = current_user.categories.find(params[:id])
  end

  def prevent_uncategorized_deletion
    if @category.uncategorized?
      redirect_to categories_path, alert: "「未分類」カテゴリーは削除できません"
    end
  end
end
