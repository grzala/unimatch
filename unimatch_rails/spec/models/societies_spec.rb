require 'rails_helper'

describe Society, 'methods' do
    
    
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
            @user1 = create_new_user(1)
            @user2 = create_new_user(2)
            @user3 = create_new_user(3)
            
            @society = create_new_soc(1)
        end
    end
        
    it "can't create societies with the same name", skip_before: true do
        society1 = Society.new({:name => "Rugby super club league", :description => "rugby stuff"})
        society2 = Society.new({:name => "Rugby super club league", :description => "rugby asdasd qqweqwe"})
        society3 = Society.new({:name => "Rugby Super Club League", :description => "rugby stuff"})
        society4 = Society.new({:name => "Rackuetball super club league", :description => "rugby stuff"})
        
        expect(society1.save).to be
        expect(society2.save).not_to be
        expect(society3.save).not_to be
        expect(society4.save).to be
    end
    
    it "can add members" do
        members = @society.get_members 
        
        @society.add_member(@user1.id)
        
        expect(members).not_to eq(@society.get_members)
        expect(@society.get_members.length).to eq(members.length + 1)
    end
    
    it "can delete members" do
        #add few members
        @society.add_member(2)
        @society.add_member(15)
        @society.add_member(28)
        
        members = @society.get_members 
        
        #get the first (or any other) user and remove him
        user = @society.get_members[0]
        
        @society.delete_member(user.id)
        
        expect(members).not_to eq(@society.get_members)
        expect(@society.get_members.length).to eq(members.length - 1)
    end
    
    it "can grant and revoke admin privileges" do
        @society.add_admin(@user1.id)
        expect(@society.get_admins_by_id.include? @user1.id).not_to be #can't add non-member as admin
        
        @society.add_member(@user1.id)
        @society.add_admin(@user1.id)
        expect(@society.get_admins_by_id.include? @user1.id).to be
        
        @society.delete_member(@user1.id)
        expect(@society.get_members_by_id.include? @user1.id).to be #cannot remove membership from admins
        
        #revoke admin privileges and membership
        @society.delete_admin(@user1.id)
        expect(@society.get_admins_by_id.include? @user1.id).not_to be
        @society.delete_member(@user1.id)
        expect(@society.get_members_by_id.include? @user1.id).not_to be 
        
    end
    
    it "can recognize members and admins" do
        expect(@society.has_member(@user1.id)).not_to be
        @society.add_member(@user1.id)
        expect(@society.has_member(@user1.id)).to be
        
        expect(@society.has_admin(@user1.id)).not_to be
        @society.add_admin(@user1.id)
        expect(@society.has_admin(@user1.id)).to be
        expect(@user1.get_administered_societies).to include(@society)
    end
        
end