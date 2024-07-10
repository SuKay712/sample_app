class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = "Not found user"
    redirect_to root_path
  end

  def new
    @user = User.new
  end
end
