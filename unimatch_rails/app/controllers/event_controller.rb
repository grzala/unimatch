class EventController < ApplicationController
    
    #if no society - choose interests
    
    def show
        @event = Event.find(params[:id])
    end
    
    
    def new
        @choices = []
        temp = {}
        temp["name"] = ""
        temp["value"] = nil
        @choices << temp
        
        User.find(session[:user_id]).get_administered_societies.each do |society|
            temp = {}
            temp["name"] = society.name
            temp["value"] = society.id
            @choices << temp
        end
    end
    
    def list
        @events = Event.all
    end
    
    def create
        if params[:recurring]
            startdate = Date.parse(params[:startdate])
            enddate = Date.parse(params[:enddate])
            cur_date = startdate
            
            @group = EventGroup.create()
            
            while cur_date <= enddate
                puts cur_date
                save_event(params[:name], params[:description], params[:location], params[:cost], cur_date, params[:hour], params[:minute], session[:user_id], params[:society_id], @group.id)
                cur_date += 7 * params[:frequency].to_i
            end
            
        else 
            date = Date.parse(params[:startdate])
            save_event(params[:name], params[:description], params[:location], params[:cost], date, params[:hour], params[:minute], session[:user_id], params[:society_id])
        end
        
        
        redirect_to :action => :list
    end
    
    def save_event(name, description, location, cost, date, hour, minute, user_id, society_id = nil, event_group_id = nil)
        @event = Event.new
        @event.name = name
        @event.description = description
        @event.location = location
        @event.cost = cost
        @event.date = date.strftime("%Y-%m-%d")
        @event.time = (hour.to_s + minute.to_s).to_i
        @event.user_id = user_id
        @event.society_id = society_id
        @event.event_group_id = event_group_id
        
        if !@event.save then puts @event.errors.full_messages end
    end
    

end
