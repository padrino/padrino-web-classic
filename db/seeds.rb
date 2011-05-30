mongorestore = `which mongorestore`.chomp

until File.exist?(mongorestore)
  mongorestore = shell.ask "Where is located mongorestore? (i.e. /usr/bin/mongorestore):"
end

command = "#{mongorestore} -d #{MongoMapper.database.name} --drop #{Padrino.root("db", "dump")} &> /dev/null"
shell.say "Executing command: #{command.inspect}"
system command

Account.collection.drop

email     = shell.ask "Which email do you want use for loggin into admin?"
password  = shell.ask "Tell me the password to use:"

shell.say ""

account = Account.create(:email => email, :name => "Foo", :surname => "Bar", :password => password, :password_confirmation => password, :role => "admin")

if account.valid?
  %w(Guide Page Post).each do |m|
    m.constantize.all.each { |o| o.author_id = account.id; o.collection.save(o.to_mongo) }
  end
  shell.say "================================================================="
  shell.say "Account has been successfully created, now you can login with:"
  shell.say "================================================================="
  shell.say "   email: #{email}"
  shell.say "   password: #{password}"
  shell.say "================================================================="
else
  shell.say "Sorry but some thing went worng!"
  shell.say ""
  account.errors.full_messages.each { |m| shell.say "   - #{m}" }
end

shell.say ""