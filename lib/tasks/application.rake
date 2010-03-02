namespace :textile do

  desc "Regenerate textile"
  task :regenerate => :environment do
    Post.regenerate_textile
    Guide.regenerate_textile
  end
end

task :author => :environment do
  print "Adding author to posts ... "
  Post.all.each { |p| p.update_attributes(:author_id => Account.first.id) }
  puts "done!"
  print "Adding author to guides ... "
  Guide.all.each { |c| c.update_attributes(:author_id => Account.first.id) }
  puts "done!"
end