class ApplicationController < ActionController::Base
  helper_method :current_user,
                :find_bookmark,
                :list_tags,
                :tutorial_name,
                :github_token_present?

  add_flash_types :success

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def find_bookmark(id)
    current_user.user_videos.find_by(video_id: id)
  end

  def tutorial_name(id)
    Tutorial.find(id).title
  end

  def four_oh_four
    raise ActionController::RoutingError, 'Not Found'
  end

  def github_token_present?
    current_user.github_token.present?
  end
end
