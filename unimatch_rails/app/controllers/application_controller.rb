class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  #connect to algorithm
  include Connect
  
  before_action :get_notifications
  
  
  def get_notifications
    if session[:user_id].nil?
      return
    end
    
    @notifs = User.find(session[:user_id]).get_notifications
    @notifs = @notifs.sort_by { |msg| msg.created_at }
    @notifs = @notifs.reverse
    @notifs = @notifs[0...10]
    @notifs = @notifs.reverse
    
    @notifs = @notifs.to_json.html_safe
  end
  
end
