module ApplicationHelper
  def nav_link_class(path)
    base = "flex flex-col items-center justify-center py-3 transition-colors"

    active = "text-blue-500 font-semibold"
    inactive = "text-gray-700 hover:text-blue-500 active:bg-gray-100"

    classes = [ base ]
    classes << (current_page?(path) ? active : inactive)

    classes.join(" ")
  end
end
