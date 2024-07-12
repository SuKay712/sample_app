class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach params.dig(:micropost, :image)
    if @micropost.save
      flash[:success] = t "create_successfully"
      redirect_to root_url

    else
      @pagy, @feed_items = pagy current_user.feed.sort_by_date_desc, items: Settings.page_size
      render "static_pages/home", status: :unprocessable_entity
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = t "delete_successfully"
    if request.referrer.nil?
      redirect_to root_url, status: :see_other
    else
      redirect_to request.referrer, status: :see_other
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit Micropost::PERMITTED_ATTRIBUTES
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_url, status: :see_other if @micropost.nil?
  end
end
