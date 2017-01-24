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
    
    def rand_set(size, a, b)
        randoms = Set.new
        loop do
            randoms << a + rand(b)
            return randoms.to_a if randoms.length >= size
        end
    end
    
    @interest_amount = Interest.maximum('id')
    
    50.times do |i|
        number = (i+1).to_s
        @user = User.create(name: scottish_names.sample, password: 'user'+number, email: 'user'+number+'@abdn.ac.uk' , surname: scottish_surnames.sample)
        
        #randomly generate interests
        @interests_no = 5 + rand(20) #between 5 and 20 interests
        @interest_id_array = rand_set(@interests_no, 1, @interest_amount)
        @interest_id_array.each do |id|
            @user.add_interest(id)
        end
    end
    puts "users created\n"
end