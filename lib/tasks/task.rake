<<<<<<< HEAD
# frozen_string_literal: true

desc 'Dropping and re-creating the tables...'
task :reset do
  if File.file?('./db/schema.rb')
    puts 'Deleting schema.rb'
    File.delete('./db/schema.rb')
  end

  sh 'rails db:drop'
  sh 'rails db:create'
  sh 'rails db:migrate'
  sh 'rails db:seed'
end

desc 'Deploy to epiDeploy.'
task :deploy do
  sh 'ssh-add'
  sh 'bundle exec ed release -d demo'
  sh 'bundle exec cap demo deploy:seed'
end

desc 'Deploy to epiDeploy without seed.'
task :deploy_no_seed do
  sh 'ssh-add'
  sh 'bundle exec ed release -d demo'
end

desc 'Update booking status to ongoing'
task update_booking_status_to_ongoing: :environment do
  # Get current date/time
  bookings = Booking.where('status = 2 AND start_datetime < ?', DateTime.now)
  bookings.each do |b|
    Notification.create(recipient: b.user, action: "started", notifiable: b, context: "U")
    Notification.create(recipient: b.item.user, action: "started", notifiable: b, context: "AM")
    UserMailer.booking_ongoing(User.find(b.user_id), Item.find(b.item_id)).deliver
    b.status = 3
    b.save
  end
end

desc 'Update booking status to late'
task update_booking_status_to_late: :environment do
  # Get current date/time
  bookings = Booking.where('status = 3 AND end_datetime < ?', DateTime.now)
  bookings.each do |b|
    Notification.create(recipient: b.user, action: "overdue", notifiable: b, context: "U")
    Notification.create(recipient: b.item.user_id, action: "overdue", notifiable: b, context: "AM")
    b.status = 7
    b.save
  end
end
=======
# frozen_string_literal: true

desc 'Dropping and re-creating the tables...'
task :reset do
  if File.file?('./db/schema.rb')
    puts 'Deleting schema.rb'
    File.delete('./db/schema.rb')
  end

  sh 'rails db:drop'
  sh 'rails db:create'
  sh 'rails db:migrate'
  sh 'rails db:seed'
end

desc 'Deploy to epiDeploy.'
task :deploy do
  sh 'ssh-add'
  sh 'bundle exec ed release -d demo'
  sh 'bundle exec cap demo deploy:seed'
end

desc 'Deploy to epiDeploy without seed.'
task :deploy_no_seed do
  sh 'ssh-add'
  sh 'bundle exec ed release -d demo'
end

desc 'Update booking status to ongoing'
task update_booking_status_to_ongoing: :environment do
  # Get current date/time
  now = DateTime.new
  bookings = Booking.where('status = 2 AND start_datetime <= ?', now)
  bookings.each do |b|
    Notification.create(recipient: b.user, action: "started", notifiable: b, context: "U")
    Notification.create(recipient: b.item.user, action: "started", notifiable: b, context: "AM")
    UserMailer.booking_ongoing(User.find(b.user_id), Item.find(b.item_id)).deliver
    b.status = 3
    b.save
  end
end

desc 'Update booking status to late'
task update_booking_status_to_late: :environment do
  # Get current date/time
  now = DateTime.now
  bookings = Booking.where('status = 3 AND end_datetime <= ?', now)
  bookings.each do |b|
    Notification.create(recipient: b.user, action: "overdue", notifiable: b, context: "U")
    Notification.create(recipient: b.item.user, action: "overdue", notifiable: b, context: "AM")
    b.status = 7
    b.save
  end
end
>>>>>>> 3ec63d8941a37c1b1c72d5d5442bd743e3f6791e
