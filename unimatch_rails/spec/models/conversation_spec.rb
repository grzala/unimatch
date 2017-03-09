require 'rails_helper'

RSpec.describe Conversation, type: :model do
    
    def create_new_user(number)
        name = "testuser"
        return User.create(name: name + number.to_s, surname: name + number.to_s, password: name + number.to_s, email: name + number.to_s + "@abdn.ac.uk")
    end


    before(:each) do
        @user1 = create_new_user(1)
        @user2 = create_new_user(2)
        @user3 = create_new_user(3)
        
        @conversation = Conversation.create_between(@user1, @user2)
    end
    
    it "can get users" do
        users = @conversation.get_users 
        expect(users).to match_array([@user2, @user1]) #order should not be important
        
        expect(@conversation.is_member? @user1).to be
        expect(@conversation.is_member? @user2).to be
    end
    
    it "can add and remove users" do
        users1 = @conversation.get_users
        @conversation.add_user(@user3)
        users2 = @conversation.get_users
        
        expect(users1).not_to match_array(users2)
        expect(users2).to include(@user3)
        expect(@conversation.is_member? @user3).to be
        expect(users1.length).to eq(users2.length-1)
        
        
        @conversation.remove_user(@user3)
        users3 = @conversation.get_users
        expect(users1).to match_array(users3)
        expect(users3).not_to include(@user3)
        expect(@conversation.is_member? @user3).not_to be
        
    end
    
    
end
