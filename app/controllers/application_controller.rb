class ApplicationController < ActionController::Base
  breadcrumb 'Home', :root_path
  before_action :configure_permitted_parameters, if: :devise_controller?

  def show_errors!(object)
    flash[:danger] = object.errors.full_messages.first
    redirect_to request.referrer
  end

  def show_success!(name, types)
    flash[:success] = "Successful #{types} #{name}"
  end

  protected

  def configure_permitted_parameters
    attributes = [:name, :email, :password, :password_confirmation]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
    devise_parameter_sanitizer.permit(:account_update, keys: attributes)
  end

  def after_sign_in_path_for(resource)
    users_homepage_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
