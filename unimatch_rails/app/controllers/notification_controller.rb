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
            temp_dic = {}
            temp_dic['seen'] = notif.seen
            temp_dic['sender'] = notif.sender
            temp_dic['link'] = notif.link
            temp_dic['information'] = notif.information
            temp_dic['image_url'] = User.find(notif.sender.to_i).avatar_url(:display)
            temp << temp_dic
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