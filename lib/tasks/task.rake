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

desc 'update_booking_status_to_ongoing'
task :update_booking_status_to_ongoing => :environment do
  # Get current date/time
  now = Time.new
  bookings = Booking.where("status = 2 AND start_datetime <= ?", now)
  bookings.each do |b|
    b.status = 3
    b.save
  end
end

desc 'update_booking_status_to_late'
task :update_booking_status_to_late => :environment do
  # Get current date/time
  now = Time.new
  bookings = Booking.where("status = 3 AND end_datetime <= ?", now)
  bookings.each do |b|
    b.status = 7
    b.save
  end
end
