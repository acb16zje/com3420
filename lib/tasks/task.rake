desc 'Dropping and re-creating the tables...'
task :reset do

  if File.file?('./db/schema.rb')
    puts 'Deleting schema.rb'
    File.delete('./db/schema.rb')
  end

  sh 'rails db:migrate'
  sh 'rails db:drop'
  sh 'rails db:create'
  sh 'rails db:migrate'
  sh 'rails db:seed'
end

desc 'Deploy to epiDeploy.'
task :deploy do
  sh 'bundle exec ed release -d demo'
  sh 'bundle exec cap demo deploy:seed'
end
