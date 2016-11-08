class SessionController < ApplicationController
    def new
        if session[:user_id]
           redirect_to user_url(id: session[:user_id])
        end
    end
    
    def create
        if @current_user = User.authenticate(params[:email], params[:password])
            session[:user_id] = @current_user.id
            session[:user_name] = @current_user.name
            redirect_to root_url
        else
            print params[:email]
            print "aboooooove"
            redirect_to login_url, :alert => "Username or password is invalid"
        end
    end
    
    def destroy
        session[:user_id] = nil
        @current_user = nil
        redirect_to root_url
    end
end
