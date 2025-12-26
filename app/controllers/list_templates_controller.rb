class ListTemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list_template, only: [ :show, :to_lists ]
  before_action :set_user_template, only: [ :destroy ]

  def index
    templates = current_user.list_templates.includes(:category, :list_template_items)

    @global_templates = ListTemplate.global
    @user_templates    = templates.user_created.order(created_at: :desc)
  end

  def show
    @template_items = @list_template.list_template_items.order(:position)
  end

  def destroy
    @user_template.destroy
    redirect_to list_templates_path, notice: "リストを削除しました"
  end

  def to_lists
    if current_user.lists.exists?(title: @list_template.title)
      redirect_to list_template_path(@list_template),
        alert: "同じタイトルのリストが既にあります"
      return
    end

    ActiveRecord::Base.transaction do
      list = current_user.lists.create!(
        title: @list_template.title, category: @list_template.category, scheduled_on: Date.current
      )

      @list_template.list_template_items.order(:position).each do |template_item|
        list.items.create!(name: template_item.name)
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
  end

  def set_user_template
    @user_template = current_user.list_templates.user_created.find(params[:id])
  end
end
