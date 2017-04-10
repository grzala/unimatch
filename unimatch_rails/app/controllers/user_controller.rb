class UserController < ApplicationController
  before_action :authorize, :only => [:match, :delete]
  #contains all the function that we need for users
  def authorize
    if session[:user_id] != params[:id].to_i then redirect_to :root end
  end#if user id is not the same as id then it redirects to root, a security feature
  
  def index
    @user = User.find(session[:user_id])
    @notifs = Notification.where(user_id: @user.id)
  end#displays the user

  
  def list
    @users = User.all
  end#lists all the users, used in developement stages
  
  def match
    @matches = User.find(session[:user_id]).get_matched_users
    @matched_users = {}
    @matches.each do |id, coefficient|
      @matched_users[User.find(id)] = coefficient
    end
    @matched_users = @matched_users.sort_by {|k,v| v}.reverse
  end
  
  
  def show
    @user = User.friendly.find(params[:id])
    if request.path != user_path(@user)
      redirect_to @user, status: :moved_permanently
    end
    @events = @user.get_society_current_events + @user.get_user_events
    
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
    
    @in_societies = @user.get_societies
    
    @image_url = @user.avatar_url(:display)
    
    if session[:user_id] != params[:id]
      @con = Conversation.get_conversation_between(User.friendly.find(session[:user_id]), User.friendly.find(params[:id]))
    end
  end#used to display users own profile page and also other users profile pages, using json request for the calendar
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_param)
    @user.save
    
    if @user.save
      flash[:success] = "Account created successfuly. Please log in."
      redirect_to root_path
    elsif (:password) != (:password_confirmation)
      flash[:warning] = "Passwords are different"
      puts flash[:warning]
      redirect_to :controller => :session, :action => :new
        
    else
      flash[:warning] = "Account not created"
      puts flash[:warning]
      redirect_to :controller => :session, action => :new
    end
    
  end#creates new user account, relates to the welcom controller
  
  def choose_interests
    @user = User.friendly.find(params[:id])
    if request.path != choose_interests_path(@user)
      redirect_to choose_interests_path, status: :moved_permanently
    end
    @interests = Interest.retrieve_as_dictionary
    @allinterests = Interest.all
    @interests1 = @allinterests.where(interest_group_id: 1)
    @interests2 = @allinterests.where(interest_group_id: 2)
    @interests3 = @allinterests.where(interest_group_id: 3)
    @interests4 = @allinterests.where(interest_group_id: 4)
    @interests5 = @allinterests.where(interest_group_id: 5)
    @interests6 = @allinterests.where(interest_group_id: 6)
    @interests7 = @allinterests.where(interest_group_id: 7)
    @user_interests = @user.get_interests
    @user_interests_imp = @user_interests.take(5)
    @user_interests = @user.get_interests
    @user_interests.drop(5)
  end#used for choosing the interests
  
  def update_interests
    @a= params[:imp_interests]
    @a=@a.take(5)
    puts "asdasdsd"
    puts @a
    @b= params[:interests]
    @c= @a+@b
    User.friendly.find(params[:id]).update_interests_by_ids(@c)
    redirect_to user_url, :id => params[:id]
  end
  
  def edit
    @user = User.friendly.find(params[:id])
  end#used to edit users details
  
  def update
    @user = User.find_by_id(params[:id])
    if @user.update_attributes(user_param)
      redirect_to :action => :show
    end
  end
  
  def delete
    User.find(params[:id]).destroy
    redirect_to :action => :list
  end#deletes user
  
  def messages
    @msgs = Message.get_messages(session[:user_id], params[:id])
    @msgs = @msgs.sort_by { |msg| msg.created_at }
    
    @users = {}
    @users[session[:user_id]] = User.find(session[:user_id])
    @users[params[:id].to_i] = User.find(params[:id])
    
    @message = Message.new()
    
  end#used for messages with other users, u message them from their profile page

  def switch_favourite
    if session[:user_id].nil?
      return 
    end
    
    user = User.find(session[:user_id])
    user2 = User.find(params[:user_id])
    
    if user.get_favourites.include? user2
      user.remove_favourite(user2)
    else
      user.add_favourite(user2)
    end
    
  end
  
  helper_method :common_interests
  
  private
  def user_param
    params.require(:user).permit(:email, :name, :surname, :password, :password_confirmation, :avatar, :slug)
  end#private params for security reasons
end

