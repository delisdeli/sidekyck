# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
admin = User.create(name:'admin', email:'admin@email.com', password:'password', password_confirmation:'password')
admin.admin = true
admin.save
user1 = User.create(name:'user1', email:'user1@email.com', password:'password', password_confirmation:'password')
