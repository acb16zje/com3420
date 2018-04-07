# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

Category.create(name: 'Cameras', icon: '<i class="fas fa-camera fa-6x"></i>', has_peripheral: 1, is_peripheral: 0)
Category.create(name: 'Cameras - Peripheral', icon: '<i class="fas fa-camera fa-6x">P</i>', has_peripheral: 0, is_peripheral: 1)
Category.create(name: 'Data Logger', icon: '<i class="material-icons">dock</i>', has_peripheral: 0, is_peripheral: 0)
Category.create(name: 'Laptops', icon: '<i class="material-icons">computer</i>', has_peripheral: 1, is_peripheral: 0)
Category.create(name: 'Laptops - Peripheral', icon: '<i class="material-icons">computerP</i>', has_peripheral: 0, is_peripheral: 1)

User.create(email: 'wkkhaw1@sheffield.ac.uk', givenname: 'Wei Kin', sn: 'Khaw', permission_id: 3, username: 'aca16wkk')
User.create(email: 'zjeng1@sheffield.ac.uk', givenname: 'Zer Jun', sn: 'Eng', permission_id: 3, username: 'acb16zje')
User.create(email: 'atchapman1@sheffield.ac.uk', givenname: 'Alex', sn: 'Chapman', permission_id: 3, username: 'aca16atc')
User.create(email: 'rchatterjee1@sheffield.ac.uk', givenname: 'Ritwesh', sn: 'Chatterjee', permission_id: 3, username: 'aca16rc')
# User.create(email: 'erica.smith@sheffield.ac.uk', permission_id: 3)

Item.create(user_id: 1, category_id: '1', condition: 'Like New', name: 'GoPro Hero 5', location: 'Diamond',
            manufacturer: 'GoPro', model: 'Hero 5', serial: 'GPH5', acquisition_date: '2018-02-09', purchase_price: 100.1, has_peripheral: 1)
Item.create(user_id: 1, category_id: '2', condition: 'Like New', name: 'MicroSD Card', location: 'Diamond',
            manufacturer: 'Kingston', model: 'Flash Card', serial: 'SD322', acquisition_date: '2018-03-09', purchase_price: 10.1, parent_asset_serial: 'GPH5', has_peripheral: 0)
Item.create(user_id: 1, category_id: '2', condition: 'Like New', name: 'MicroSD Card', location: 'Diamond',
            manufacturer: 'Kingston', model: 'Flash Card', serial: 'SD644', acquisition_date: '2018-03-09', purchase_price: 10.1, parent_asset_serial: 'GPH5', has_peripheral: 0)
Item.create(user_id: 2, category_id: '4', condition: 'Like New', name: 'MacBook Pro 15-inch', location: 'Diamond',
            manufacturer: 'Apple', model: 'MacBookPro14,3', serial: 'MPTR212/A', acquisition_date: '2018-03-22', purchase_price: 2349.00, has_peripheral: 1)
Item.create(user_id: 2, category_id: '5', condition: 'Like New', name: 'Charging Cable', location: 'Diamond',
            manufacturer: 'Apple', model: 'Cable', serial: 'CC322', acquisition_date: '2018-03-22', purchase_price: 9.00, has_peripheral: 0)
Item.create(user_id: 1, category_id: '3', condition: 'Like New', name: 'Flir Thermal Camera', location: 'Diamond',
            manufacturer: 'Apple', model: 'FLIR ONE PRO', serial: 'FLR322', acquisition_date: '2018-03-22', purchase_price: 349.00, has_peripheral: 0)
