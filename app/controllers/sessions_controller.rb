class SessionsController < ApplicationController
  before_action :find_by_email, only: :create
  def new; end

  def create
    if @user&.authenticate params.dig(:session, :password)
      if @user.activated?
        forwarding_url = session[:forwarding_url]
        reset_session
        params.dig(:session, :remember_me) == "1" ? remember(user) : forget(user)
        log_in user
        redirect_to forwarding_url || user
      else
        flash[:warning] = t "errors.account_not_activated"
        redirect_to root_url, status: :see_other
      end
    else
      flash.now[:danger] = t "errors.invalid_email_password_combination"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private
  def find_by_email
    @user = User.find_by email: params.dig(:session, :email)&.downcase
  end
end
