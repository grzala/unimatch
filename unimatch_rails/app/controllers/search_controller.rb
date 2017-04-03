class SearchController < ApplicationController
    
    def query
        
        @search_string = params[:search_query]
        
    end
    
end
