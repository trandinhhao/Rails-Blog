class UsersController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]
  def index
    current_user_id = Current.user.id
    @users = User.where.not(id: current_user_id)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params.require(:user).permit(:email_address, :password, :password_confirmation))

    if @user.save
      redirect_to new_session_path, notice: "Đăng ký thành công!!!"
    else
      render :new
    end
  end
end
