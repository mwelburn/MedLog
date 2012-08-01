class HomeController < ApplicationController

  def index
    @title = "Medical Tracker"
  end

  def error
    @title = "Error"
  end

end