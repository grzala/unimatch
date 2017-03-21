class UserController < ApplicationController
  before_action :authorize, :only => [:match, :delete]
  
  def authorize
    if session[:user_id] != params[:id].to_i then redirect_to :root end
  end
  
  def index
    @user = User.find(session[:user_id])
    @notifs = Notification.where(user_id: @user.id)
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
  end
  
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
    
  end
  
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
  end
  
  def update_interests
    redirect_to user_url, :id => params[:id]
  end
  
  def edit
    @user = User.friendly.find(params[:id])
  end
  
  def update
    @user = User.find_by_id(params[:id])
    if @user.update_attributes(user_param)
      redirect_to :action => :show
    end
  end
  
  def delete
    User.find(params[:id]).destroy
    redirect_to :action => :list
  end
  
  def messages
    @msgs = Message.get_messages(session[:user_id], params[:id])
    @msgs = @msgs.sort_by { |msg| msg.created_at }
    
    @users = {}
    @users[session[:user_id]] = User.find(session[:user_id])
    @users[params[:id].to_i] = User.find(params[:id])
    
    @message = Message.new()
    
  end

  
  def common_interests(user1, user2)
      #return User.get_common_interests(user1, user2, important = true)
  end
  
  helper_method :common_interests
  
  private
  def user_param
    params.require(:user).permit(:email, :name, :surname, :password, :password_confirmation, :avatar, :slug)
  end
end

