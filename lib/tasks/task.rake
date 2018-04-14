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
    UserMailer.booking_ongoing(b).deliver
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
    UserMailer.asset_overdue(b).deliver
    b.status = 7
    b.save
  end
end

desc 'Remind user of late loan return'
task remind_late_booking: :environment do
  bookings = Booking.where('status = 7')
  bookings.each do |b|
    Notification.create(recipient: b.user, action: "overdue", notifiable: b, context: "U")
    Notification.create(recipient: b.item.user_id, action: "overdue", notifiable: b, context: "AM")
    UserMailer.asset_overdue(b).deliver
  end
end

desc 'Remind user their booking ends soon'
task remind_ending_booking: :environment do
  bookings = Booking.where('status = 3 AND end_datetime < ?', (DateTime.now + 3.days))
  bookings.each do |b|
    UserMailer.asset_due(b).deliver
  end
end
