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
    end
    
    def create
        @society = Society.new(society_param)
        @society.save
        
        #creating a society, you become an admin and member instantly
        @society.add_member(session[:user_id])
        @society.add_admin(session[:user_id])
        
        Connector.reinitialize_algorithm_db
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
    
    private
    def society_param
        params.require(:society).permit(:name, :description)
    end
        
     
end