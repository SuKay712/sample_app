class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t("not_found_user")
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      flash[:success] = t("welcome_to_the_sample_app")
      redirect_to @user, status: :see_other
    else
      # byebug
      render :new, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(User::PERMITTED_ATTRIBUTES)
  end
end
