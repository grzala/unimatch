class UserController < ApplicationController
  def list
    @users = User.all
  end
  
  def match
    @matches = Connector.get_user_matches(params[:id])
    @matched_users = {}
    User.all.each do |user|
      @matched_users[user] = @matches[user.id]
    end
    @matched_users = @matched_users.sort_by {|k,v| v}.reverse
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def user_param
    params.require(:user).permit(:email, :name, :surname, :password)
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
    params[:interests]
    
    redirect_to user_url, :id => params[:id]
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    
    if @user.update_attributes(user_param)
      Connector.reinitialize_algorithm_db
      redirect_to :action => 'list'
    end
  end
  
  def delete
    User.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end

