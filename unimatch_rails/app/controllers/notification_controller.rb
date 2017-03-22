class NotificationController < ActionController::Base
    
    def get_notifications
        if session[:user_id] == nil 
            return
        end
        
        @user = User.find(session[:user_id])
        
        from = params[:from]
        to = params[:to]
        count = to.to_i - from.to_i
        
        @notifs = Notification.where(:user_id => session[:user_id]).order(created_at: :desc).limit(count).offset(from)
        
        
        #compile imortant information
        temp = []
        @notifs.each do |notif|
            temp << notif.prepare
        end
        
        #@notifs = @notifs.to_json.html_safe
        @notifs = temp.to_json.html_safe
        
        
        
		respond_to do |format|
			format.json {
				render json: @notifs
			}
	    end
        
    end
    
    
end