class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to root_path, :notice => "'404' Page not found! The page might have been broken or removed."
  end

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :about, :avatar, :email, :password, :password_confirmation, :current_password, :admin_category, :grade_id, :category_id, :egrade])
    # devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :about, :avatar, :email, :password, :password_confirmation, :current_password, :admin_category, :grade_id, :category_id, :egrade) }
  end
end
