desc 'Dropping and re-creating the tables...'
task :reset do

  if File.file?('./db/schema.rb')
    puts 'Deleting schema.rb'
    File.delete('./db/schema.rb')
  end

  sh 'rails db:migrate'
  sh 'rails db:reset'
  sh 'rails db:migrate'
end

desc 'Deploy to epiDeploy.'
task :deploy do
  sh 'bundle exec ed release -d demo'
  sh 'bundle exec cap demo deploy:seed'
end
