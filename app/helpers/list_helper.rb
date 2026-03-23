module ListHelper
  def translated_status(list)
    t("lists.status.#{list.status}")
  end

  def status_color(status)
    {
      waiting: "bg-gray-200 text-gray-700 border border-gray-300 text-sm",
      checking: "bg-gradient-to-r from-blue-100 to-blue-200 text-blue-700 border border-blue-300 text-base font-medium",
      completed: "bg-gradient-to-r from-green-500 to-green-600 text-white shadow-md text-base font-bold"
    }[status.to_sym]
  end

  def list_action_menu(list, from: nil)
    render partial: "lists/action_menu", locals: { list: list, from: from }
  end

  # フィルターの各項目のスタイル
  def active_filters(filter_params, current_category)
    filters = []

    if filter_params[:status].present?
      filters << filter_tag(
        "ステータス: #{t("enums.list.status.#{filter_params[:status]}")}",
        :blue,
        :status
      )
    end

    if filter_params[:category_id].present? && current_category
      filters << filter_tag(
        "カテゴリ: #{current_category.name}",
        :green,
        :category_id
      )
    end

    if filter_params[:priority] == "true"
      filters << filter_tag("高優先度のみ", :red, :priority)
    end

    if filter_params[:q].present?
      filters << filter_tag("検索: #{filter_params[:q]}", :amber, :q)
    end

    filters
  end

  def render_active_filters
    safe_join(active_filters, " ")
  end

  def safe_filter_params
    params.permit(:status, :category_id, :priority, :q, :sort)
          .to_h.reject { |_, v| v.blank? }
  end

  FILTER_COLORS = {
    blue:  "bg-blue-100 text-blue-800 hover:text-blue-900",
    green: "bg-green-100 text-green-800 hover:text-green-900",
    red:   "bg-red-100 text-red-800 hover:text-red-900",
    amber: "bg-amber-100 text-amber-800 hover:text-amber-900"
  }.freeze

  def filter_tag(label, color, *remove_params)
    content_tag(:span,
      class: "inline-flex items-center gap-1 px-3 py-1 text-sm rounded-full #{FILTER_COLORS[color.to_sym]}") do
      concat content_tag(:span, label)
      concat link_to(
        lists_path(safe_filter_params.except(*remove_params)),
        data: { turbo_frame: "lists" },
        class: "hover:opacity-80"
      ) { close_icon }
    end
  end

  def close_icon
    <<~SVG.html_safe
      <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
        <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"/>
      </svg>
    SVG
  end
end
