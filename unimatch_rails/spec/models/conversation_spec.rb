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
    
    it "relays messages between users" do
        #send messages
        message1 = "sent from user1"
        message2 = "sent from user2"
        @conversation.send_message(@user1, message1)
        @conversation.send_message(@user2, message2)
        expect(@conversation.get_messages.length).to eq(2)
        expect(@conversation.get_messages.map {|message| message.body}).to include(message1)
        expect(@conversation.get_messages.map {|message| message.body}).to include(message2)
        
        
        #cannot message if not member of conversation
        @initial_messages = @conversation.get_messages
        message3 = "sent from user 3"
        @msg = @conversation.send_message(@user3, message3)
        expect(@msg).to eq(nil)
        expect(@initial_messages).to match_array(@conversation.get_messages)
        expect(@conversation.get_messages.map {|message| message.body}).not_to include(message3)
        
        #add as member and send message
        @conversation.add_user(@user3)
        @msg = @conversation.send_message(@user3, message3)
        expect(@msg).to be
        expect(@initial_messages).not_to match_array(@conversation.get_messages)
        expect(@conversation.get_messages).to include(@msg)
        expect(@conversation.get_messages.map {|message| message.body}).to include(message3)
        
    end
    
end
