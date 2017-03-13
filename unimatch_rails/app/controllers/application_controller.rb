class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  #connect to algorithm
  include Connect
  
  before_action :get_notifications
  
  
  def get_notifications
    if session[:user_id].nil?
      return
    end
    
    @notifs = Notification.where(:user_id => session[:user_id]).order(created_at: :desc).limit(10)
    
    @notifs = @notifs.to_json.html_safe
  end
  
end
