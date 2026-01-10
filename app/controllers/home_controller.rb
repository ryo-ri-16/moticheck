class HomeController < ApplicationController
  before_action :authenticate_user!, only: :index

  def index
    base = current_user.lists.includes(:category)

    @today_lists = base.scheduled_today
                      .order(priority: :desc, scheduled_time: :asc)

    @near_lists  = base.near_future
                      .order(priority: :desc, scheduled_on: :asc, scheduled_time: :asc)

    @past_lists  = base.past_not_complete
                      .order(priority: :desc, scheduled_on: :desc, scheduled_time: :desc)
  end

  def welcome
    if user_signed_in?
      redirect_to home_path
    end
  end
end
