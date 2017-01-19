require 'rails_helper'

describe UserController, 'controller', :type => :controller do
    
    it "can't access other users details" do
    
        get :edit, params: {:id => 12}
        is_expected.to redirect_to root_path
        
        get :match, params: {:id => 12}
        is_expected.to redirect_to root_path
        
        #get :delete, params: {:id => 12}
        #is_expected.to redirect_to root_path
        
        get :choose_interests, params: {:id => 12}
        is_expected.to redirect_to root_path
        
    end
    
end