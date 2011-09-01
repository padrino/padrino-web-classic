source :rubygems

# Project requirements
gem 'rake'
gem 'rack-flash'
gem 'thin' # or mongrel
gem 'RedCloth'
gem 'popen4'

# Component requirements
gem 'haml'
gem 'yui-compressor',           :require => 'yui/compressor'
gem 'diff-lcs',                 :require => 'diff/lcs'
gem 'bson_ext',      '~>1.3.1', :require => nil
gem 'mongo_mapper',  '~>0.9.1'
gem 'disqus'
gem 'rdoc'
gem 'pdfkit'

# Test requirements
group :test do
  gem 'rspec'
  gem 'SystemTimer', :require => "system_timer", :platform => :mri_18
  gem 'rack-test',   :require => "rack/test"
end

# Padrino EDGE
# %w(core gen helpers mailer admin cache).each do |gem|
#   gem 'padrino-' + gem, :path => '/Developer/src/padrino/padrino-framework/padrino-' + gem
# end
# gem 'padrino-contrib', :path => '/Developer/src/padrino/padrino-contrib'

gem 'padrino', '0.10.2'
gem 'padrino-contrib', '~>0.1.5'
