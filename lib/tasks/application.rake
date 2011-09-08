desc "Export db"
task :export do
  FileUtils.rm_rf(Padrino.root('/db/export'))
  FileUtils.mkdir_p(Padrino.root('/db/export'))
  [Post, Guide, Page].each do |klass|
    objs = klass.all
    objs.each_with_index do |o,i|
      print ("\r=> Exporting %s" % klass.name).ljust(20) + " [%s/%s]" % [i+1, objs.size]; $stdout.flush
      path = Padrino.root('db/export/%s' % klass.collection_name)
      FileUtils.mkdir_p(path)
      attributes = { :title => o.title }
      attributes[:categories] = o.categories.map(&:name).join(', ') if o.respond_to?(:categories)
      attributes[:label]      = o.label.name       if o.respond_to?(:label)
      attributes[:tags]       = o.tags             if o.respond_to?(:tags)
      attributes[:author]     = o.author.full_name if o.respond_to?(:author)
      body = o.body.gsub(/\r/, '').split("\n").map { |line|
        line.length > 110 ? line.gsub(/(.{1,110})(\s+|$)/, "\\1\n").strip : line.strip
      }.join("\n")
      File.open(File.join(path, "#{o.to_param}.en.textile"), "w") do |f|
        f.puts attributes.to_yaml.gsub(/\s+$/, '')
        f.puts "---"
        f.puts body
      end
    end # klass
    puts
  end # Post, Guide, Page
end # export

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
