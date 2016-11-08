puts 'creating interests...'

interests_yaml = YAML.load_file('db/seeds/yaml/interests.yaml')

interests_yaml.each do |group, interests|
    @i = InterestGroup.new(name: group)
    @i.save
    interests.each do |interest|
       Interest.create(name: interest, interest_group_id: @i.id)
    end
end




puts "interests created\n"