class ErrorsController < ApplicationController
  layout 'errors'

  skip_before_action :ie_warning
  skip_before_action :verify_authenticity_token, only: [:error_422]

  def error_403
    @error_code = 403
    @error_message = 'Access Denied'
  end

  def error_404
    @error_code = 404
    @error_message = 'Page not found'
  end

  def error_422
    @error_code = 422
    @error_message = 'Change Rejected'
  end

  def error_500
    @error_code = 500
    @error_message = 'Internal Server Error'
  end

  def ie_warning
  end

  def javascript_warning
  end

end
