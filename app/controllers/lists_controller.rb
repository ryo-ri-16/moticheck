class ListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list, only: [ :show, :edit, :update, :destroy, :complete, :start_checking, :finish_checking, :back_waiting, :reuse ]
  before_action :set_categories, only: [ :new, :edit, :create, :update ]

  def index
    @checking_lists = current_user.lists.checking
    @today_lists    = current_user.lists.scheduled_today
    @all_lists      = current_user.lists.includes(:category).order(scheduled_on: :asc, scheduled_time: :asc, updated_at: :desc)

    if params[:status].present?
      @all_lists = @all_lists.with_status(params[:status])
    end

    if params[:category_id].present?
      @all_lists = @all_lists.where(category_id: params[:category_id])
    end

    @categories = current_user.categories.ordered
  end

  def show
    @list_items = @list.list_items.includes(:item).order(:position)
    @checked_count = @list_items.where(checked: true).count
  end

  def new
    @list = List.new
  end

  def create
    @list = current_user.lists.build(list_params)
    assign_category

    if @list.save
      redirect_to @list, notice: "リストを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    assign_category

    if @list.update(list_params)
      redirect_to @list, notice: "リストを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @list.destroy
    redirect_to lists_path, notice: "リストを削除しました"
  end

  def complete
    @list.completed!
    redirect_to @list, notice: "リストを完了しました"
  end

  def incomplete
    @list.waiting!
    redirect_to @list, notice: "リストを未完了に戻しました"
  end

  def scheduled_today
    @lists = current_user.lists.scheduled_today
    render :index
  end

  def start_checking
    if @list.start_checking!
      redirect_to @list, notice: "チェックを開始しました"
    else
      redirect_to @list, alert: "ステータスの更新に失敗しました"
    end
  end

  def finish_checking
    if @list.finish_checking!
      redirect_to @list, notice: "チェックが完了しました"
    else
      redirect_to @list, alert: "ステータスの更新に失敗しました"
    end
  end

  def back_waiting
    if @list.back_to_waiting!
      redirect_to @list, notice: "待機中に戻しました"
    else
      redirect_to @list, alert: "ステータスの更新に失敗しました"
    end
  end

  def reuse
    @new_list = @list.deep_clone include: :list_items
    @new_list.status = :waiting

    @new_list.list_items.each do |li|
      li.checked = false
    end

    if @new_list.save
      redirect_to @new_list, notice: "リストを再利用しました"
    else
      redirect_to @list, alert: "再利用に失敗しました"
    end
  end

  private

  def set_list
    @list = current_user.lists.find(params[:id])
  end

  def list_params
    params.require(:list).permit(
      :title, :status, :priority, :note, :scheduled_on, :scheduled_time, :category_id
    )
  end

  def set_categories
    @categories = current_user.categories.ordered
  end

  def assign_category
    return unless params[:new_category_name].present?

    category_name = params[:new_category_name].strip

    if category_name.blank?
      @list.errors.add(:base, "カテゴリー名を入力してください")
      return
    end

    category = Category.find_or_create_by(
      user: current_user, name: category_name)

    if category.persisted?
      @list.category = category
    else
      @list.errors.add(:base, "カテゴリーの作成に失敗しました: #{category.errors.full_messages.join(', ')}")
    end
  end
end
