class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include ApplicationHelper
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Доступ запрещен!"
    redirect_to root_url
  end

  if Rails.env.development?
    Rack::MiniProfiler.authorize_request
  end

end
