module Caching
  extend ActiveSupport::Concern

  module InstanceMethods
    def cache_key(*suffixes)
      cache_key = case
                    when !persisted?
                      "#{self.class.name.downcase}-new"
                    when timestamp = self[:updated_at]
                      "#{self.class.name.downcase}-#{id}-#{timestamp.to_s(:number)}"
                    else
                      "#{self.class.name.downcase}-#{id}"
                  end
      cache_key += "#{suffixes.join('-')}" unless suffixes.empty?
      cache_key
    end
  end # InstanceMethods
end # Caching
MongoMapper::Document.send(:include, Caching)