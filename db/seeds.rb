# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Category.create(name: 'Cameras', tag: 'CAM')
Category.create(name: 'Data Logger', tag: 'DL')
Category.create(name: 'Laptops', tag: 'LPT')

User.create(email: 'wkkhaw1@sheffield.ac.uk', givenname: 'Wei Kin', sn: 'Khaw', permission_id: 3, username: 'aca16wkk')
User.create(email: 'zjeng1@sheffield.ac.uk', givenname: 'Zer Jun', sn: 'Eng', permission_id: 3, username: 'acb16zje')
User.create(email: 'atchapman1@sheffield.ac.uk', givenname: 'Alex', sn: 'Chapman', permission_id: 3, username: 'aca16atc')
User.create(email: 'rchatterjee1@sheffield.ac.uk', givenname: 'Ritwesh', sn: 'Chatterjee', permission_id: 3, username: 'aca16rc')
# User.create(email: 'erica.smith@sheffield.ac.uk', permission_id: 3)

Item.create(user_id: 1, category_id: '1', condition: 'Like New', name:'GoPro Hero 5', location: 'Diamond', serial_id: 'CAM00001',
    manufacturer: 'GoPro', model: 'Hero 5', serial: 'GPH5', acquisition_date: '2018-03-09', purchase_price: 100.1)
Item.create(user_id: 2, category_id: '3', condition: 'Like New', name:'MacBook Pro 15-inch', location: 'Diamond', serial_id: 'LPT00001',
    manufacturer: 'Apple', model: 'MacBookPro14,3', serial: 'MPTR212/A', acquisition_date: '2018-03-22', purchase_price: 2349.00)
