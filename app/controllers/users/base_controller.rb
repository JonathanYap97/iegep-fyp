class Users::BaseController < ActionController::Base
  breadcrumb 'Home', :root_path
  before_action :authenticate_user!
  before_action :get_user
  before_action :get_uri

  layout 'dashboard'

  private

  def get_user
    @user = current_user
  end

  def get_uri
    @base_url = URI(request.fullpath).path.split('/').last
  end
end
