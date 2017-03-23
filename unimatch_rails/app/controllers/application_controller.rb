class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  #application controller, a supper class
  #connect to algorithm
  include Connect
  
  before_action :get_user_image
  
  def get_user_image
    if !session[:user_id].nil?
      @logged_user = User.find(session[:user_id])
      @image_thumbnail = @logged_user.avatar_url(:display)
    end
  end
  
end
