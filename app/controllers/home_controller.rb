class HomeController < ApplicationController
  before_action :authenticate_user!, only: :index

  def index
    base = current_user.lists.includes(:category)

    @checking_lists = base.checking.scheduled_asc.prioritize

    @today_lists = base.scheduled_today.scheduled_asc.prioritize

    @near_lists  = base.near_future.scheduled_asc.prioritize

    @past_lists  = base.past_not_complete.scheduled_asc.prioritize
  end

  def welcome
    if user_signed_in?
      redirect_to home_path
    end
  end
end
