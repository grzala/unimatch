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
        
        redirect_to :action => 'list'
    end

    def show
        @society = Society.find(params[:id])
    end
    
    def create_society
        @society = Society.new()
        @society.save
        Connector.reinitialize_algorithm_db
        redirect_to root_path
    end
    
    def delete
        Society.find(params[:id]).destroy
        redirect_to :action => 'list_societies'
    end
    
    def choose_interest_cathegory
        @cathegories=InterestGroup.all
        @society= Society.find(params[:id])
        @society_interest= @society.get_interest
    end
        
     
end