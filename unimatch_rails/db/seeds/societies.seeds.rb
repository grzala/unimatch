after :users do
    puts "creating societies..."
    def rand_set(size, a, b)
        randoms = Set.new
        loop do
            randoms << a + rand(b)
            return randoms.to_a if randoms.length >= size
        end
    end
    
    interests = Interest.all
    
    random_numbers = rand_set(10, 0, interests.length-1) #generate 10 societies for random interests
    
    random_numbers.each do |n|
        name = interests[n].name.capitalize + " Aberdeen University Society"
        description = "Society that specialises in " + interests[n].name.capitalize
        
        @societies = Society.create(name: name, description: description)
    end
    puts "societies created"
end