desc 'Dropping and re-creating the tables...'
task :reset do
  
  if File.file?('./db/schema.rb')
    puts 'Deleting schema.rb'
    File.delete('./db/schema.rb')
  end

  sh 'rails db:migrate'
  sh 'rake db:reset db:migrate'
end
