class ApplicationController < ActionController::Base
  
  include SessionsHelper
  
  private
  
  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
  
  # 投稿の数をカウントする
  def counts(user)
    @count_posts = user.posts.count
  end
  
end
