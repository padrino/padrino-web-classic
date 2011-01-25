# Defines our constants
PADRINO_ENV  = ENV["PADRINO_ENV"] ||= ENV["RACK_ENV"] ||= "development" unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.dirname(__FILE__) + '/..' unless defined? PADRINO_ROOT

begin
  # Require the preresolved locked set of gems.
  require File.expand_path('../../.bundle/environment', __FILE__)
rescue LoadError
  # Fallback on doing the resolve at runtime.
  require 'rubygems'
  require 'bundler'
  Bundler.setup
end

Bundler.require(:default, PADRINO_ENV)
puts "=> Located #{Padrino.bundle} Gemfile for #{Padrino.env}"

##
# REE
# http://www.rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
#
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

##
# Padrino contrib stuff
#
require 'padrino-contrib/exception_notifier'
require 'padrino-contrib/orm/mm/permalink'
require 'padrino-contrib/orm/mm/search'

Padrino.load!