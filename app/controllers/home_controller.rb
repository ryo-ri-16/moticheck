class HomeController < ApplicationController
  before_action :authenticate_user!, only: :index

  def index
    @today_lists = current_user.lists.scheduled_today.order(scheduled_time: :asc).includes(:category, :list_items)
    @near_lists = current_user.lists.near_future.order(scheduled_on: :asc, scheduled_time: :asc).includes(:category, :list_items)
    @past_lists = current_user.lists.past_not_complete.order(scheduled_on: :desc, scheduled_time: :desc).includes(:category, :list_items)
  end

  def welcome
    if user_signed_in?
      redirect_to home_path
    end
  end
end
