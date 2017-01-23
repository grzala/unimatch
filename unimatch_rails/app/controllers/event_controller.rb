class EventController < ApplicationController
    
    def new
        @event = Event.new
    end
    
    def create
        @event = Event.new()
        @event.name = params[:name]
        @event.description = params[:description]
        @event.location = params[:location]
        @event.cost = params[:cost]
        #@event.recurring = params[:recurring]
        @event.name = params[:name]
        @event.startdate = Date.parse(params[:startdate])
        @event.enddate = Date.parse(params[:enddate])
        @event.time = (params[:hour].to_s + params[:minute].to_s).to_i
        
        
        
        
        
        @event.save
        
        redirect_to root_path
    end
    

end
