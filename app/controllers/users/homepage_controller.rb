class Users::HomepageController < Users::BaseController
  def index

  end

  def profile

  end

  def update
    @update = @user.update!(profile_params)
    redirect_to root_path if @update
  end

  def change_password
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    
    @update = @user.update!(password_params)
    redirect_to request.referrer if @update
  end

  private

  def profile_params
    params.require(:user).permit(:name, :email)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
