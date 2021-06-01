class ToppagesController < ApplicationController
  def index
    if logged_in?
      @post = current_user.posts.build  # form_with用
      @posts = current_user.feed_posts.order('created_at DESC').page(params[:page])  #一覧表示用
    end
  end
end
