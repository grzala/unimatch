after :interests do
    puts 'creating users...'
    scottish_surnames = [
        'Callum',
        'Gibb',
        'Macdonald',
        'Wilson',
        'Douglas',
        'Duncan',
        'Gordon',
        'Macintosh',
        'Graham',
        'Ramsey',
        'Scott',
        'Sterling',
        'Compatangelo',
    ]
    
    scottish_names = [
        'Callum',
        'Ian',
        'Rory',
        'William',
        'Bruce',
        'Fergus',
        'Angus',
        'Graham',
        'Ernesto',
    ]
    
    if User.all.length < 40
    
        def rand_set(size, a, b)
            randoms = Set.new
            loop do
                randoms << a + rand(b)
                return randoms.to_a if randoms.length >= size
            end
        end
        
        @interest_amount = Interest.all.length
        
        50.times do |i|
            number = (i+1).to_s
            @user = User.create(name: scottish_names.sample, password: 'user'+number, email: 'user'+number+'@abdn.ac.uk' , surname: scottish_surnames.sample)
            
            if !@user.valid? 
                puts "ERROR CREATING USERS"
                puts @user.errors.count.to_s + " error"
                puts @user.errors.full_messages
                puts "REMEMBER TO DROP DB BEFORE RESEEDING"
                break
            end
            
            #randomly generate interests
            @interests_no = 5 + rand(20) #between 5 and 20 interests
            @interest_id_array = rand_set(@interests_no, 1, @interest_amount)
            @interest_id_array.each do |id|
                @user.add_interest(id)
            end
        end
        puts "users created\n"
    else 
        puts "over 40 users, no need to seed"
    end
end