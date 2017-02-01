class UserController < ApplicationController
  
  before_action :authorize, :only => [:edit, :match, :choose_interests, :delete]
  
  def authorize
    if session[:user_id] != params[:id].to_i then redirect_to :root end
  end
  
  def list
    @users = User.all
  end
  
  def match
    @matches = Connector.get_user_matches(params[:id])
    @matched_users = {}
    @matches.each do |id, coefficient|
      @matched_users[User.find(id)] = coefficient
    end
    @matched_users = @matched_users.sort_by {|k,v| v}.reverse
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_param)
    @user.save
    Connector.reinitialize_algorithm_db
    
    redirect_to root_path
  end
  
  def choose_interests
    @interests = Interest.retrieve_as_dictionary
    @user = User.find_by_id(params[:id])
    @user_interests = @user.get_interests
  end
  
  def update_interests
    User.find_by_id(params[:id]).update_interests_by_ids(params[:interests])
    Connector.reinitialize_algorithm_db
    
    redirect_to user_url, :id => params[:id]
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    
    if @user.update_attributes(user_param)
      Connector.reinitialize_algorithm_db
      redirect_to :action => :list
    end
  end
  
  def delete
    User.find(params[:id]).destroy
    redirect_to :action => :list
  end
  
  private
  def user_param
    params.require(:user).permit(:email, :name, :surname, :password)
  end
end

