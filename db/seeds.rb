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

Category.create(name: 'Cameras', tag: 'CAM')
Category.create(name: 'Data Logger', tag: 'DL')
User.create(email: 'wkkhaw1@sheffield.ac.uk', givenname: 'Wei Kin', sn: 'Khaw', permission_id: 3, username: 'aca16wkk')
User.create(email: 'zjeng1@sheffield.ac.uk', givenname: 'Zer Jun', sn: 'Eng', permission_id: 3, username: 'acb16zje')
User.create(email: 'atchapman1@sheffield.ac.uk', givenname: 'Alex', sn: 'Chapman', permission_id: 3, username: 'aca16atc')
User.create(email: 'rchatterjee1@sheffield.ac.uk', givenname: 'Ritwesh', sn: 'Chatterjee', permission_id: 2, username: 'aca16rc')
