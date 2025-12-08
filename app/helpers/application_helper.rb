module ApplicationHelper
  def nav_link_class(path)
    base_class = "flex flex-col items-center justify-center py-3 transition-colors"
    if current_page?(path)
      "#{base_class} text-blue-500 font-semibold"
    else
      "#{base_class} text-gray-700 hover:text-blue-500 active:bg-gray-100"
    end
  end
end
