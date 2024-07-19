class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @pagy, @feed_items = pagy current_user.feed.sort_by_date_desc, items: Settings.page_size
    end
  end

  def help; end

  def contact; end
end
