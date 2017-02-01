puts 'creating interests...'

interests_yaml = YAML.load_file('db/seeds/yaml/interests.yaml')

interests_yaml.each do |group, interests|
    @i = InterestGroup.new(name: group)
    @i.save
    interests.each do |interest|
       @interest = Interest.create(name: interest, interest_group_id: @i.id)
       if !@interest.valid? 
            puts "ERROR CREATING INTERESTS"
            puts @interest.errors.count.to_s + " error"
            puts @interest.errors.full_messages
            puts "REMEMBER TO DROP DB BEFORE RESEEDING"
            break
        end
    end
end




puts "interests created\n"