puts 'creating interests...'

interests_yaml = YAML.load_file('db/seeds/yaml/interests.yaml')

interests_yaml.each do |group, interests|
    @i = InterestGroup.find_by_name(group)
    if @i == nil then @i = InterestGroup.create(name: group) end
        
    interests.each do |interest|
       @interest = Interest.create(name: interest, interest_group_id: @i.id)
    end
end




puts "interests created\n"