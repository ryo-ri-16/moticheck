class MypagesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @lists_count = current_user.lists.count
  end

  def term
  end

  def privacy
  end
end
