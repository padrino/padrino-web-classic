# Defines our constants
PADRINO_ENV  = ENV["PADRINO_ENV"] ||= ENV["RACK_ENV"] ||= "development" unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.dirname(__FILE__) + '/..' unless defined?(PADRINO_ROOT)

require 'rubygems'
require 'bundler/setup'

Bundler.require(:default, PADRINO_ENV)
puts "=> Located #{Padrino.bundle} Gemfile for #{Padrino.env}"

##
# REE
# http://www.rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
#
GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=)

##
# Remove cached css/js
#
`rm -rf #{Padrino.root("public", "javascripts", "padrino-bundle.js")}`
`rm -rf #{Padrino.root("public", "stylesheets", "padrino-bundle.css")}`

##
# Padrino contrib stuff
#
require 'padrino-contrib/exception_notifier'
require 'padrino-contrib/orm/mm/permalink'
require 'padrino-contrib/orm/mm/search'
require 'padrino-contrib/helpers/assets_compressor'
require 'open-uri'

# Fix for my Passenger Environment
PDFKit.configuration.wkhtmltopdf = "/usr/local/bin/wkhtmltopdf"

# Padrino::Logger::Config[:development][:log_level] = :debug

# Used for grep changes on github
OpenSSL::SSL.send(:remove_const, :VERIFY_PEER)
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

# Boot Padrino
Padrino.load!