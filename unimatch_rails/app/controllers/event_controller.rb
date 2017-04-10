class EventController < ApplicationController
  #contains all the functions required for events to work  
    #if no society - choose interests
    
    def show
        @user = User.find(session[:user_id])
        @event = Event.find(params[:id])
        @participants = @event.get_participants
        @invited = @event.get_invited
        @society = nil
        if @event.society_id != nil
            @society = Society.find(@event.society_id)
            @is_admin = @society.has_admin(@user.id)
            @members_to_invite = @society.get_members - @invited - [@user]
        end
        
        @time_str = @event.time.to_s[0..1] + ":" + @event.time.to_s[1..2]
        if @time_str[0] == "0"
            @time_str = [1...@time_str.length]
        end
        
        @participates = @participants.include? @user
        
        @favourite_to_invite = @user.get_favourites - @invited - [@user]
    end
    
    
    def new
        @choices = []
        temp = {}
        temp["name"] = "No society"
        temp["value"] = nil
        @choices << temp
        
        User.find(session[:user_id]).get_administered_societies.each do |society|
            temp = {}
            temp["name"] = society.name
            temp["value"] = society.id
            @choices << temp
        end
    end#creates the new event, if user is admin of a society then he can create an event on the societies behalf
    
    def list
        @events = Event.all
    end#lists all the events
    
    def join_leave
        @event = Event.find(params[:id])
        if !@event.has_participant(session[:user_id])
            
            @event.add_participant(session[:user_id])  
        else
            @event.delete_participant(session[:user_id])
        end
        
        redirect_to :action => :show, :id => @event.id
    end#allows user to participate on events
    
    def create
        time = params[:time].split(":")
        hour = time[0]
        minute = time[1]
        
        if params[:recurring]
            startdate = Date.parse(params[:startdate])
            enddate = Date.parse(params[:enddate])
            cur_date = startdate
            
            @group = EventGroup.create()
            
            while cur_date <= enddate
                puts cur_date
                save_event(params[:name], params[:description], params[:location], params[:cost], cur_date, hour, minute, session[:user_id], params[:society_id], @group.id)
                cur_date += 7 * params[:frequency].to_i
            end
            
        else 
            date = Date.parse(params[:startdate])
            save_event(params[:name], params[:description], params[:location], params[:cost], date, hour, minute, session[:user_id], params[:society_id])
        end
        
        
        redirect_to :action => :list
    end#creates now event, get parameteers and send them to save event function
    
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
    end#saves the event to db
    
    
    def invite_all_members
        @society = Society.find(params[:society_id]) 
        @event = Event.find(params[:event_id])
        @user = User.find(session[:user_id])
        
        if !@society.has_admin(@user.id) or !(@society.get_events.include? @event)
            return
        end
        
        @members = @society.get_members
        @invited = @event.get_invited
        @joined = @event.get_participants
        @to_invite = @members - (@invited + @joined).uniq
        
        @to_invite.each do |user|
            @event.invite(@user, user)
        end
        
    end
    
    def invite
        sender = User.find(session[:user_id])
        recipient = User.find(params[:user_id])
        event = Event.find(params[:event_id])
        
        event.invite(sender, recipient)
    end
        
    
    private
    def event_param
        params.require(:event).permit(:name, :description, :location, :cost, :date)
    end#private params for security reasons
end
