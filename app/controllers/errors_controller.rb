class ErrorsController < ApplicationController
  skip_before_action :ie_warning
  skip_before_action :verify_authenticity_token, only: [:error_422]

  def error_403
    render 'errors/error_403'
  end

  def error_404
    render 'errors/error_404'
  end

  def error_422
    render 'errors/error_422'
  end

  def error_500
    render 'errors/error_500'
  end

  def ie_warning; end

  def javascript_warning
    render layout: false
  end

end
