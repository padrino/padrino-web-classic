module Search
  module ClassMethods
    def has_search(*fields)
      class_inheritable_accessor  :search_fields
      write_inheritable_attribute :search_fields, fields
    end

    def search(text, options={})
      if text
        re = Regexp.new(Regexp.escape(text), 'i').to_json
        where = search_fields.map { |field| "this.#{field}.match(#{re})" }.join(" || ")
        options.merge!("$where" => where)
      end
      options.delete(:paginate) ? paginate(options) : all(options)
    end
  end
end # Permalink
MongoMapper::Document.append_extensions(Search::ClassMethods)