class LoginController < ApplicationController
  def index
    render layout: false
  end

  def create
    if true
      redirect_to root_path
    end
  end
end