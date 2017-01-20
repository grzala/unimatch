require 'rails_helper'

describe Society, 'methods' do
    
    it "can add members" do
        society = Society.find(3)
        
        members = society.get_members 
        
        user = User.new({:name => "Adam", :password => "adam123", :email => "adam.adam@adam.ac.uk"})
        user.save
        
        society.add_member(user.id)
        
        expect(members).not_to eq(society.get_members)
        expect(society.get_members.length).to eq(members.length + 1)
    end
    
    it "can delete members" do
        society = Society.find(3)
        
        #add few members
        society.add_member(2)
        society.add_member(15)
        society.add_member(28)
        
        members = society.get_members 
        
        user = society.get_members[0]
        
        society.delete_member(user.id)
        
        expect(members).not_to eq(society.get_members)
        expect(society.get_members.length).to eq(members.length - 1)
    end
    
    it "can grant and revoke admin privileges" do
        society = Society.find(3)
        
        user = User.new({:name => "Adam2", :password => "adam123", :email => "adam2.adam@adam.ac.uk"})
        user.save
        
        society.add_admin(user.id)
        expect(society.get_admins_by_id.include? user.id).not_to be #can't add non-member as admin
        
        society.add_member(user.id)
        society.add_admin(user.id)
        expect(society.get_admins_by_id.include? user.id).to be
        
        
        society.delete_member(user.id)
        expect(society.get_members_by_id.include? user.id).to be #cannot remove membership from admins
        
        #revoke admin privileges and membership
        society.delete_admin(user.id)
        expect(society.get_admins_by_id.include? user.id).not_to be
        society.delete_member(user.id)
        expect(society.get_members_by_id.include? user.id).not_to be 
        
    end
    
    it "can't create societies with the same name" do
        society1 = Society.new({:name => "Rugby super club league", :description => "rugby stuff"})
        society2 = Society.new({:name => "Rugby super club league", :description => "rugby asdasd qqweqwe"})
        society3 = Society.new({:name => "Rugby Super Club League", :description => "rugby stuff"})
        society4 = Society.new({:name => "Rackuetball super club league", :description => "rugby stuff"})
        
        expect(society1.save).to be
        expect(society2.save).not_to be
        expect(society3.save).not_to be
        expect(society4.save).to be
        
        
    end
    
end