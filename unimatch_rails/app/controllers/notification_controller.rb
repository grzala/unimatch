class NotificationController < ActionController::Base
    
    def get_notifications
        if session[:user_id] == nil 
            return
        end
        
        @user = User.find(session[:user_id])
        
        @notifs = Notification.where(:user_id => session[:user_id]).order(created_at: :desc).limit(10)
        
        @notifs = @notifs.to_json.html_safe
        
        puts params
        
		respond_to do |format|
			format.json {
				render json: @notifs
			}
	    end
        
    end
    
    
end