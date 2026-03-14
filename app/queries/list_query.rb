class ListQuery
  def initialize(user:, params:)
    @user   = user
    @params = params
  end

  def call
    scope = base_scope
    scope = filter_status(scope)
    scope = filter_category(scope)
    scope = filter_priority(scope)
    scope = search(scope)
    scope = sort(scope)
    scope.page(@params[:page]).per(20)
  end

  private

  def base_scope
    @user.lists.includes(:category)
  end

  def filter_status(scope)
    return scope unless @params[:status].present?
    scope.with_status(@params[:status])
  end

  def filter_category(scope)
    return scope unless @params[:category_id].present?
    scope.where(category_id: @params[:category_id])
  end

  def filter_priority(scope)
    return scope unless @params[:priority] == "true"
    scope.high_priority
  end

  def search(scope)
    return scope unless @params[:q].present?
    scope.where("title ILIKE ?", "%#{@params[:q]}%")
  end

  def sort(scope)
    case @params[:sort]
    when "name_asc"      then scope.name_asc
    when "name_desc"     then scope.name_desc
    when "updated_old"   then scope.updated_old
    when "updated_recent" then scope.updated_recent
    when "created_old" then scope.created_old
    when "created_recent" then scope.created_recent
    when "used_recent"   then scope.used_recent
    when "scheduled_asc" then scope.scheduled_asc
    else
      scope.updated_recent
    end
  end
end
