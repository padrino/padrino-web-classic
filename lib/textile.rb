module Textile
  module ClassMethods
    def has_textile(*fields)
      include InstanceMethods
      options = fields.extract_options!
      options.reverse_merge!(:internal_links => :blog)
      class_inheritable_accessor  :textile_fields, :textile_options
      write_inheritable_attribute :textile_fields, fields
      write_inheritable_attribute :textile_options, options
      before_save :generate_textile
      textile_fields.each { |f| key "#{f}_formatted", String }
      textile_fields.each { |f| key "#{f}_chapters", Array   } if textile_options[:chapters]
    end

    def label_for(label)
      label.downcase.gsub(/\W/, '-').
                     gsub(/-+/, '-').
                     gsub(/-$/, '').
                     gsub(/^-/, '')
    end
  end

  module InstanceMethods

    protected
      def generate_textile
        textile_fields.each do |textile_field|
          next if self[textile_field].blank?
          html = RedCloth.new(self[textile_field]).to_html
          # Parse code
          html.gsub!(/<pre\s?(?:lang="(.*?)")>(?:<code.*?>)?(.*?)(?:<\/code>)?<\/pre>/m) do
            replacements = { '&amp;' => '&', '&quot;' => '"', '&gt;' => '>', '&lt;' => '<' }
            lang = $1
            code = $2.gsub(/&(?:amp|quot|[gl]t);/) { |entity| replacements[entity] }
            CodeRay.scan(code, lang).div(:css => :class)
          end
          # Prarse charpters
          if textile_options[:chapters]
            chapters = []
            html.gsub!(/(<h2>(.*)<\/h2>)/) do
              chapters << $2
              "<a name=\"#{self.class.label_for($2)}\">&nbsp</a>\n" + $1
            end
            self.send("#{textile_field}_chapters=", chapters)
          end
          # Parse internal links
          html.gsub!(/\[\[(.+)\]\]/) do
            page, name = *$1.split("|") # this allow to rename link ex: [[Page Name|link me]]
            name ||= page
            "<a href=\"/#{textile_options[:internal_links]}/#{Post.permalink_for(page.strip)}\">#{name.strip}</a>"
          end
          # Write content
          self.send("#{textile_field}_formatted=", html)
        end
      end
  end # InstanceMethods
end # Permalink
MongoMapper::Document.append_extensions(Textile::ClassMethods)