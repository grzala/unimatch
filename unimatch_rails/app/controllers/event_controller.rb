class EventController < ApplicationController
    
    def new
    end
    
    def create
        @event = Event.new
        @event.name = params[:name]
        @event.description = params[:description]
        @event.location = params[:location]
        @event.cost = params[:cost]
        #@event.recurring = params[:recurring]
        @event.startdate = Date.parse(params[:startdate]).strftime("%Y-%m-%d")
        @event.enddate = Date.parse(params[:enddate]).strftime("%Y-%m-%d")
        @event.time = (params[:hour].to_s + params[:minute].to_s).to_i
        
        
        
        
        
        if !@event.save then puts @event.errors.full_messages end
        
        #redirect_to root_path
    end
    

end
