# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Item.create(id: '1', category_id: '1', condition: 'Available', name:'gopro',
# 	location: 'diamond', created_at: '2018-02-23 15:17:11.475084', updated_at: '2018-02-23 15:17:11.47508')
#
# Item.create(id: '2', category_id: '1', condition: 'Available', name:'test',
# 	location: 'diamond', created_at: '2018-02-23 16:21:13.106582', updated_at: '2018-02-23 16:21:13.106582')
#
# Item.create(id: '3', category_id: '1', condition: 'Available', name:'macbook air',
# 	location: 'diamond', created_at: '2018-02-23 16:55:51.015394', updated_at: '2018-02-23 16:55:51.015394')

User.where(email:
               'my.email.address@sheffield.ac.uk').first_or_create(password:
                                                                       'Password123', password_confirmation: 'Password123')
User.where(email:
               'wkkhaw1@sheffield.ac.uk').first_or_create(password:
                                                                       'aaaa1234', password_confirmation: 'aaaa1234')
