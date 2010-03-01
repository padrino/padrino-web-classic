namespace :textile do

  desc "Regenerate textile"
  task :regenerate => :environment do
    Post.regenerate_textile
    Guide.regenerate_textile
  end

end