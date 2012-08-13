class HomeController < ApplicationController

  def index
    if user_signed_in?
      redirect_to current_user
    end
  end

  def error
    @title = "Error"
  end

end