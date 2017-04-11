require 'rails_helper'

describe SocietyPost, 'methods' do
    
    
    def create_new_user(number)
        name = "testuser"
        return User.create(name: name + number.to_s, surname: name + number.to_s, password: name + number.to_s, email: name + number.to_s + "@abdn.ac.uk")
    end
    
    def create_new_soc(number)
        name = "testsociety"
        return Society.create(name: name + number.to_s, description: name + number.to_s + " description")
    end


    before(:each) do |example|
		unless example.metadata[:skip_before]
            @user = create_new_user(1)
            @society = create_new_soc(1)
        end
    end
    
    it "can add post" do
        posts = @society.get_posts
        expect(posts).to be_empty
        
        @society.add_post(@user, "Message body")
        posts = @society.get_posts
        expect(posts).not_to be_empty
    end
    
    it "logs user joining and leaving society" do
        @society.add_member(@user.id)
        post = @society.get_posts[0]
        
        expect(post.user_id).to eq(@user.id)
        expect(post.body).to eq("Joined the society")
        
        @society.delete_member(@user.id)
        post = @society.get_posts[0]
        
        expect(post.user_id).to eq(@user.id)
        expect(post.body).to eq("Left the society")
    end
    
    it "logs adding and removing admins" do
        @society.add_member(@user.id)
        @society.add_admin(@user.id)
        
        post = @society.get_posts[0]
        
        expect(post.user_id).to eq(@user.id)
        expect(post.body).to eq("Became an administrator")
        
        @society.delete_admin(@user.id)
        post = @society.get_posts[0]
        
        expect(post.user_id).to eq(@user.id)
        expect(post.body).to eq("Administrator status revoked")
    end
        
    
    
end

=begin
describe EventPost, 'methods' do
    
    
    def create_new_user(number)
        name = "testuser"
        return User.create(name: name + number.to_s, surname: name + number.to_s, password: name + number.to_s, email: name + number.to_s + "@abdn.ac.uk")
    end
    
    def create_new_soc(number)
        name = "testsociety"
        return Society.create(name: name + number.to_s, description: name + number.to_s + " description")
    end


    before(:each) do |example|
		unless example.metadata[:skip_before]
            @user1 = cre    `ate_new_user(1)
            @user2 = create_new_user(2)
            @user3 = create_new_user(3)
            
            @society = create_new_soc(1)
        end
    end
end
=end