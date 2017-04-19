class SessionController < ApplicationController
    #same as welcome controller
    layout 'login'
    
    def new
        if session[:user_id]
           redirect_to user_url(id: session[:user_id])
        end
    end
    

    def create
        if @current_user = User.authenticate(params[:email], params[:password])
            session[:user_id] = @current_user.id
            session[:user_name] = @current_user.name
            
            #####
            cookies.signed[:user_id] = @current_user.id
            #####
            
            user = User.find(session[:user_id])
            interests = user.get_interests
            
            if interests.length > 0
                return redirect_to :controller => :user, :action => :show, :id => session[:user_id]
            else
                return redirect_to :controller => :user, :action => :choose_interests, :id => session[:user_id]
            end
        else
            flash[:warning] = "Password and email do not match"
            print params[:email]
            return redirect_to login_url, :alert => "Username or password is invalid"
        end
    end
    
    def destroy
        session[:user_id] = nil
        @current_user = nil
        
        cookies.signed[:user_id] = nil
        
        redirect_to root_url
    end
end
