class ListTemplatesController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_list_template, only: [ :edit, :update, :show, :to_lists ]
  before_action :set_categories, only: [ :new, :edit, :create, :update ]
  before_action :set_user_template, only: [ :destroy ]

  def index
    @global_templates = ListTemplate.global.includes(:category)

    if user_signed_in?
      templates = current_user.list_templates.includes(:category)
      @user_templates = templates.user_created.ordered
    else
      @user_templates = ListTemplate.none
    end
  end

  def show
    @template_items = @list_template.list_template_items.order(:position)
  end

  def new
    @list_template = ListTemplate.new
  end

  def create
    @list_template = current_user.list_templates.build(list_template_params)
    assign_category if params[:new_category_name].present?

    if @list_template.save
      redirect_to @list_template, notice: "テンプレートを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @back_path = request.referer || list_templates_path
  end

  def update
    assign_category if params[:new_category_name].present?

    if @list_template.update(list_template_params)
      redirect_to @list_template, notice: "テンプレートを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @list_template.destroy
    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = "テンプレートを削除しました"
      end
      format.html { redirect_to list_templates_path, notice: "テンプレートを削除しました" }
    end
  end

  # リストへコピー
  def to_lists
    ActiveRecord::Base.transaction do
      list = current_user.lists.create!(
        title: @list_template.title, category: @list_template.category, scheduled_at: Time.current, status: :waiting
      )

      @list_template.list_template_items.order(:position).each do |template_item|
        item = Item.find_or_create_by!(name: template_item.name)

        list.list_items.create!(item: item, position: template_item.position, checked: false)
      end

      redirect_to list_path(list), notice: "テンプレートからリストを作成しました"
    end
  rescue ActiveRecord::RecordInvalid
    redirect_to list_templates_path, alert: "リスト作成に失敗しました"
  end

  private

  def set_list_template
    @list_template = ListTemplate
                      .for_user(current_user)
                      .find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to list_templates_path,
                alert: "このテンプレートは既に削除されています"
    nil
  end

  def set_categories
    @categories = Category.for_user(current_user).ordered
  end

  def set_user_template
    @list_template = current_user.list_templates.user_created.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to list_templates_path, alert: "このテンプレートは既に削除されています"
    nil
  end

  def list_template_params
    params.require(:list_template)
      .permit(:title, :description, :category_id, :repeat_type, weekdays: [])
  end

  def assign_category
    return unless params[:new_category_name].present?

    category_name = params[:new_category_name].strip

    if category_name.blank?
      @list_template.errors.add(:base, "カテゴリー名を入力してください")
      return
    end

    category = Category.find_or_create_by(
      user: current_user, name: category_name)

    if category.persisted?
      @list_template.category = category
    else
      @list_template.errors.add(:base, "カテゴリーの作成に失敗しました: #{category.errors.full_messages.join(', ')}")
    end
  end
end
