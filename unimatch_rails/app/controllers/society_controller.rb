class SocietyController < ApplicationController
# containing all the function that we use for societies    
    def list
       @societies = Society.all
       @sesion = session[:user_id]
    end
    
    def join_leave
        @society = Society.find(params[:id])
        if !@society.has_member(session[:user_id])
            
            @society.add_member(session[:user_id])  
        else
            @society.delete_member(session[:user_id])
        end
        
        redirect_to :action => :list
    end#used so that the user can join are leave the society

    def show
        @society = Society.find(params[:id])
        
        @events = @society.get_events
        
        @events_json = []
        @events.each do |event|
            temp = {
            title: "\n" + event.get_owner_name,
            url: url_for(:controller => :event, :action => :show, :id => event.id),
              start: event.date.year.to_s + '-' + ('%02d' % event.date.month).to_s + '-' + event.date.day.to_s + 'T' + event.time.to_s.slice(0...2) + ':' + event.time.to_s.slice(2...4),
              description: event.name + "\n" + event.description,
            }
            
            @events_json << temp
        end
    
        @events_json = @events_json.to_json.html_safe
        
    end#displays the society base on the society id
    
    def new
        @society = Society.new
        @interests = Interest.all
    end
    
    def create
        @society = Society.new(society_param)
        @society.save
        
        #creating a society, you become an admin and member instantly
        @society.add_member(session[:user_id])
        @society.add_admin(session[:user_id])
        
        #interests THIS IS TEMPORARY IT SHOULD HAPPEN THIS WAY
        (0..params[:interest_count].to_i).each do |i|
            param = ("id_" + i.to_s).to_sym
            @society.add_interest(params[:selected_interests][param].to_i) #THIS CANNOT STAY LIKE THIS
        end
        
        redirect_to :action => :list
    end#creates a new society and add the creator as a admin, and member, redirects to list of all the societies
    
    def delete
        Society.find(params[:id]).destroy
        redirect_to :action => :list
    end#deletes a society and redirects to list
    
    def choose_interest_category
        @cathegories = InterestGroup.all
        @society = Society.find(params[:id])
        @society_interest = @society.get_interest
    end
    
    def match
        @matches = User.find(session[:user_id]).get_matched_societies
        @matched_societies = {}
        @matches.each do |id, coefficient|
          @matched_societies[Society.find(id)] = coefficient
        end
        @matched_societies = @matched_societies.sort_by {|k,v| v}.reverse
    end#matches the user with the societies
    
    private
    def society_param
        params.require(:society).permit(:name, :description, :avatar)
    end#private parameters for security reasons
        
     
end