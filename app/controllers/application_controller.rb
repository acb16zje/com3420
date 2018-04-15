# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :update_headers_to_disable_caching
  before_action :ie_warning

  ## The following are used by our Responder service classes so we can access
  ## the instance variable for the current resource easily via a standard method
  # def resource_name
  #   controller_name.demodulize.singularize
  # end

  # def current_resource
  #   instance_variable_get(:"@#{resource_name}")
  # end

  # def current_resource=(val)
  #   instance_variable_set(:"@#{resource_name}", val)
  # end

  # Catch NotFound exceptions and handle them neatly, when URLs are mistyped or mislinked
  rescue_from ActiveRecord::RecordNotFound do
    redirect_to '/404'
  end
  rescue_from CanCan::AccessDenied do
    redirect_to '/403'
  end

  # IE over HTTPS will not download if browser caching is off, so allow browser caching when sending files
  def send_file(file, opts = {})
    response.headers['Cache-Control'] = 'private, proxy-revalidate' # Still prevent proxy caching
    response.headers['Pragma'] = 'cache'
    response.headers['Expires'] = '0'
    super(file, opts)
  end

  layout :layout

  private

  def update_headers_to_disable_caching
    response.headers['Cache-Control'] = 'no-cache, no-cache="set-cookie", no-store, private, proxy-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '-1'
  end

  def ie_warning
    redirect_to(ie_warning_path) if request.user_agent.to_s =~ /MSIE [6-7]/ && request.user_agent.to_s !~ /Trident\/7.0/
  end

  def layout
    # only turn it off for login pages:
    is_a?(Devise::SessionsController) ? false : 'application'
    # or turn layout off for every devise controller:
    # devise_controller? && "application"
  end
end
