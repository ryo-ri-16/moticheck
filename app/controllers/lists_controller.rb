class ListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list, only: [ :show, :edit, :update, :destroy, :complete, :start_checking, :finish_checking, :back_waiting, :reuse, :to_templates ]
  before_action :set_categories, only: [ :new, :edit, :create, :update ]
  before_action :prevent_edit_while_checking, only: [ :edit, :update, :reuse, :destroy, :to_templates ]

  def index
    @lists = ListQuery.new(
      user: current_user,
      params: params
    ).call

    @categories = Category
      .for_user(current_user)
      .select("DISTINCT ON (LOWER(name)) *")
      .order("LOWER(name), user_id NULLS FIRST")
  end

  def show
    @list_items = @list.list_items.includes(:item).order(:position)

    @unchecked_items = @list_items.reject(&:checked)
    @checked_items   = @list_items.select(&:checked)

    @total_count   = @list_items.size
    @checked_count = @checked_items.size

    @back_path = request.referer || lists_path
  end

  def new
    @list = List.new
  end

  def create
    @list = current_user.lists.build(list_params)
    assign_category

    unless current_user.can_create_more_lists?
      redirect_to root_path, alert: "ゲスト利用では8件まで作成できます"
      return
    end

    if @list.save
      redirect_to @list, notice: "リストを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @back_path = request.referer || lists_path
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

    @lists = ListQuery.new(
      user: current_user,
      params: params
    ).call

    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = "リストを削除しました"
      end
      format.html { redirect_to lists_path, notice: "リストを削除しました" }
    end
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
    @new_list = @list.build_reuse

    if @new_list.save
      redirect_to @new_list, notice: "リストを再利用しました"
    else
      redirect_to @list, alert: "再利用に失敗しました"
    end
  end

  def to_templates
    unless current_user.can_copy?
      redirect_to lists_path,
                  alert: "テンプレートのコピーはユーザー登録後にご利用いただけます"
      return
    end

    list_template = nil

    ActiveRecord::Base.transaction do
      list_template = current_user.list_templates.create!(
        title: @list.title,
        category: @list.category
      )

      @list.list_items.order(:position).each do |list_item|
        list_template.list_template_items.create!(name: list_item.item.name)
      end
    end

    redirect_to list_template_path(list_template),
                notice: "リストからテンプレートを作成しました"

  rescue ActiveRecord::RecordInvalid
    redirect_to list_path(@list),
                alert: "テンプレート作成に失敗しました"
  end

  def prevent_edit_while_checking
    return unless @list.checking?

    redirect_to @list, alert: "チェック中は操作できません"
  end

  private

  def set_list
    @list = current_user.lists.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to lists_path, alert: "このリストは既に削除されています"
    return # rubocop:disable Style/RedundantReturn
  end

  def list_params
    params.require(:list).permit(
      :title, :status, :priority, :note, :scheduled_at, :category_id
    )
  end

  def set_categories
    @categories = Category.for_user(current_user).ordered
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
