class ApplicationController < ActionController::Base
  helper_method :current_user
  # https://stackoverflow.com/questions/27673352/how-access-to-helper-current-user-in-model-rails
  # https://hackernoon.com/building-a-simple-session-based-authentication-using-ruby-on-rails-9tah3y4j
  helper_method :logged_in?
  helper_method :new_nonce

  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def new_nonce
    SecureRandom.uuid
  end
end
