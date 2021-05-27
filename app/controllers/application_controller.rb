class ApplicationController < ActionController::Base
  
  include SessionsHelper
  
  private
  
  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
  
  def counts(user)
    # 投稿の数をカウントする
    @count_posts = user.posts.count
    # フォロー数
    @count_followings = user.followings.count
    # フォローワー数
    @count_followers = user.followers.count
  end
  
end
