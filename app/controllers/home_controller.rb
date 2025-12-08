class HomeController < ApplicationController
  before_action :authenticate_user!, only: :index

  def index
  end

  def welcome
    if user_signed_in?
      redirect_to home_path
    end
  end
end
