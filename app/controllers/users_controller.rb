class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy(User.sort_by_name, items: Settings.page_size)
  end

  def show
    @pagy, @microposts = pagy @user.microposts.sort_by_date_desc, items: Settings.page_size
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t "check_email"
      redirect_to root_url, status: :see_other
    else
      flash[:danger] = t "errors.sign_up"
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "update_successfully"
      redirect_to @user
    else
      flash[:danger] = t "errors.update"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "delete_successfully"
    else
      flash[:danger] = t "delete_fail"
    end
    redirect_to users_path
  end

  def following
    @title = t "following"
    @pagy, @users = pagy @user.following, items: Settings.page_size
    render :show_follow
  end

  def followers
    @title = t "follower"
    @pagy, @users = pagy @user.followers, items: Settings.page_size
    render :show_follow
  end


  private
  def user_params
    params.require(:user).permit User::PERMITTED_ATTRIBUTES
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "errors.not_found"
    redirect_to root_url
  end

  def correct_user
    return if current_user?(@user)

    flash[:danger] = t "errors.dont_have_permission"
    redirect_to root_url
  end

  def admin_user
    return if current_user.admin?

    flash[:danger] = t "errors.you_are_not_admin"
    redirect_to root_url, status: :see_other
  end
end
