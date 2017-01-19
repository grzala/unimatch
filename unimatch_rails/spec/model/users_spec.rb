require 'rails_helper'

describe User, 'methods' do
    
  it "can create user" do
	username = "puser"
	pass = "useruser"
	mail = "user@abdn.ac.uk"
  
	user = User.new
	user.name = username
	user.password = pass
	user.email = mail
	user.save
	
	user2 = User.find(user.id)
	
	expect(user2).to be
	expect(user2.name).to eq(username)
	expect(user2.email).to eq(mail)
	expect(user2.hashed_password).not_to eq(pass)
	expect(user2.salt).to be
	
	expect(User.authenticate(mail, pass)).to be
  end
  
  it "verifies uniqueness of emails" do
	username = "puser"
	pass = "useruser"
	mail1 = "thisguyhere@abdn.ac.uk"
	mail2 = "THisGUyHere@abdn.ac.uk"
	
	user1 = User.new({:name => username, :password => pass, :email => mail1})
	expect(user1.save).to be
	user2 = User.new({:name => username, :password => pass, :email => mail2})
	expect(user2.save).not_to be
      
  end
  
  it "fails on too short password" do
	username = "puser"
	pass = "lal"
	mail = "user@user.com"
  
	user = User.new
	user.name = username
	user.password = pass
	user.email = mail
	expect(user.save).not_to be
  end
  
  it "fails on wrong emal" do
	username = "puser"
	pass = "useruser"
	mail = "deprdepr"
  
	user = User.new
	user.name = username
	user.password = pass
	user.email = mail
	expect(user.save).not_to be
	
	username = "puser"
	pass = "useruser"
	mail = "deprdepr@notac.uk"
  
	user2 = User.new
	user2.name = username
	user2.password = pass
	user2.email = mail
	expect(user2.save).not_to be
	
  end
  
  it "can add or delete interests" do
     user = User.find(1)
     initial_interests = user.get_interests_by_id
     
     interests_ids = [1, 4, 5, 2]
     interests_ids.each do |id|
        user.add_interest(id) 
     end
     expect(initial_interests).not_to eq(user.get_interests_by_id)
     
     interests_ids.each do |id|
        if !initial_interests.include? id #do not delete if interest was there from the beginning
            user.delete_interest(id) 
        end
     end
     expect(initial_interests).to eq(user.get_interests_by_id)
     
  end
  
  after(:all) do
  	users = User.all
  	users.each do |user|
  		#if user.id > 50 then user.destroy end
  	end
  end
  
end
