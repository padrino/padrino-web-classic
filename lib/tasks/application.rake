namespace :textile do

  desc "Regenerate textile"
  task :regenerate => :environment do
    print "Regenerating textitle for Posts ... "
    Post.regenerate_textile; puts "DONE"
    print "Regenerating textitle for Guides ... "
    Guide.regenerate_textile; puts "DONE"
    print "Regenerating textitle for Pages ... "
    Page.regenerate_textile; puts "DONE"
  end
end