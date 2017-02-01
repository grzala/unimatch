class SocietyController < ApplicationController
    
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
    end

    def show
        @society = Society.find(params[:id])
    end
    
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
    end
    
    def delete
        Society.find(params[:id]).destroy
        redirect_to :action => :list
    end
    
    def choose_interest_category
        @cathegories = InterestGroup.all
        @society = Society.find(params[:id])
        @society_interest = @society.get_interest
    end
    
    def match
        @matches = Connector.get_society_matches(params[:id])
        puts @matches
        @matched_societies = {}
        @matches.each do |id, coefficient|
          @matched_societies[Society.find(id)] = coefficient
        end
        @matched_societies = @matched_societies.sort_by {|k,v| v}.reverse
    end
    
    private
    def society_param
        params.require(:society).permit(:name, :description)
    end
        
     
end