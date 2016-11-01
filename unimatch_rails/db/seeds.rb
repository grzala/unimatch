# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

@user = User.create(name: 'user1', password: 'user1', email: 'rjrjrjr@absd.ac.uk' , surname: 'surname')
@user2 = User.create(name: 'user2', password: 'user2', email: 'rjrjrjr2@awdasd.ac.uk' , surname: 'surname')

@soc = Society.create(name: 'soc1', description: 'soc1', paid: false, recurring: false, cost: 2.0)

@member = Member.create(user: @user, society: @soc)
@member = Member.create(user: @user2, society: @soc)

@uni = University.create(name: 'abdn', city: 'abdn')

@user.university = @uni

@user.save

#finding = @society_array = Member.where(:user_id => usrid)
#finding = @user_array = Member.where(:society_id => socid)