class LoginController < ApplicationController
  def index
    render layout: false
  end

  def create
    if false
      redirect_to root_path
    end
  end
end