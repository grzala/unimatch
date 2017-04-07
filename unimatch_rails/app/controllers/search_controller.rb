class SearchController < ApplicationController
    
    include Rails.application.routes.url_helpers
    
    def query
        @search_string = params[:search_query]
        
        if @search_string.length > 50 or @search_string.length <= 0
            @search_string = nil
            return
        end
        
        user_results = User.search(@search_string)
        
        society_results = Society.search(@search_string)
        
        event_results = Event.search(@search_string)
        
        max_index = [user_results.length, society_results.length, event_results.length].max
        puts society_results.length
        arrays = [user_results, society_results, event_results]
        #build results
        @results = []
        
        (0...max_index).to_a.each do |i|
            arrays.each do |array| 
                next if array.length <= i or array[i].nil?
                
                array[i].each do |item|
                    result = Hash.new
                    result['title'] = ""
                    result['img'] = ""
                    result['type'] = ""
                    result['link'] = ""
                    
                    puts item.class
                    
                    if item.is_a?(User)
                        result['title'] = item.name.capitalize + " " + item.surname.capitalize
                        result['img'] = item.avatar_url(:display)
                        result['type'] = "User"
                        result['link'] = user_path(item.id)
                        
                    elsif item.is_a?(Society)
                        result['title'] = item.name
                        result['img'] = item.avatar_url(:display)
                        result['type'] = "Society"
                        result['link'] = society_path(item.id)
                    elsif item.is_a?(Event)
                        result['title'] = item.name
                        result['img'] = nil
                        result['type'] = "Event"
                        result['link'] = event_path(item.id)
                        result['month'] = item.date.strftime("%B")
                        result['day'] = item.date.day
                        
                    else
                        #not supported
                        next
                    end
                    
                    @results << result
                end
                
            end
        end
                    
            
        
        
    end
    
end
