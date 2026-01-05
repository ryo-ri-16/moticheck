class MypagesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def term
  end

  def privacy
  end
end
