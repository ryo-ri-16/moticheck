module ListHelper
  def translated_status(list)
    t("lists.status.#{list.status}")
  end

  def status_color(status)
    case status.to_sym
    when :waiting   then "bg-gray-300"
    when :checking  then "bg-blue-500"
    when :completed then "bg-green-500"
    end
  end

  def list_action_menu(list)
    render partial: "lists/action_menu", locals: { list: list }
  end
end
