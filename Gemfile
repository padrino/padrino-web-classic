source :rubygems

# Project requirements
gem 'rake'
gem 'thin' # or mongrel
gem 'RedCloth'
gem 'popen4'

# Component requirements
gem 'haml'
gem 'yui-compressor',           :require => 'yui/compressor'
gem 'diff-lcs',                 :require => 'diff/lcs'
gem 'bson_ext',      '~>1.4.0', :require => nil
gem 'mongo_mapper',  '~>0.9.2'
gem 'disqus'
gem 'rdoc'
gem 'pdfkit'

# Test requirements
group :test do
  gem 'rspec'
  gem 'SystemTimer', :require => "system_timer", :platform => :mri_18
  gem 'rack-test',   :require => "rack/test"
end

# Padrino
if path = ENV['PADRINO_PATH']
  %w(core gen helpers mailer admin cache).each do |g|
    gem 'padrino-' + g, :path => File.join(path, 'padrino-' + g)
  end
  gem 'padrino-contrib', :path => File.expand_path('../padrino-contrib', path)
else
  gem 'padrino', '0.10.3'
  gem 'padrino-contrib', '~>0.1.9'
end
