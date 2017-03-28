after :users do
    puts "creating societies..."
    
    if Society.all.length < 5
    
        def rand_set(size, a, b)
            randoms = Set.new
            loop do
                randoms << a + rand(b)
                return randoms.to_a if randoms.length >= size
            end
        end
        
        @interest_amount = Interest.all.length
        
        random_society_ids = rand_set(10, 1, @interest_amount) #generate 10 societies for random interests
        
        random_society_ids.each do |n|
            @i = Interest.find(n)
            name = @i.name.capitalize + " Aberdeen University Society"
            description = "Society that specialises in " + @i.name.capitalize
            
            @society = Society.create(name: name, description: description)
            
            if !@society.valid? 
                puts "ERROR CREATING SOCIETIES"
                puts @society.errors.count.to_s + " error"
                puts @society.errors.full_messages
                puts "REMEMBER TO DROP DB BEFORE RESEEDING"
                break
            end
            
            #randomly generate interests
            @society.add_interest(@i.id)
            @interests_no = 4
            @interest_id_array = rand_set(@interests_no, 1, @interest_amount)
            @interest_id_array.each do |id|
                @society.add_interest(id)
            end
        end
        puts "societies created"
    else
        puts "over 5 Societies, no need to seed"
    end
end