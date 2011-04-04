module Textile
  extend ActiveSupport::Concern

  module ClassMethods
    def has_textile(*fields)
      options = fields.extract_options!
      options.reverse_merge!(:internal_links => :blog)
      class_inheritable_accessor  :textile_fields, :textile_options
      write_inheritable_attribute :textile_fields, fields
      write_inheritable_attribute :textile_options, options
      before_save :generate_textile
      textile_fields.each { |f| key "#{f}_html", String }
      textile_fields.each { |f| key "#{f}_chapters", Array } if textile_options[:chapters]
    end

    def label_for(label)
      label.downcase.gsub(/\W/, '-').
                     gsub(/-+/, '-').
                     gsub(/-$/, '').
                     gsub(/^-/, '')
    end

    def regenerate_textile
      all.each { |c| c.update_attributes(:updated_at => Time.now) }
    end
  end

  module InstanceMethods

    def diff(key)
      return unless send("#{key}_changed?")
      Diff.cs_diff(send("#{key}_was"), send(key))
    end

    protected
      def generate_textile
        textile_fields.each do |textile_field|
          next if self[textile_field].blank?
          html = RedCloth.new(self[textile_field]).to_html
          # Parse code
          html.gsub!(/<pre\s?(?:lang="(.*?)")?>(?:<code.*?>)?(.*?)(?:<\/code>)?<\/pre>/m) do
            replacements = { '&amp;' => '&', '&quot;' => '"', '&gt;' => '>', '&lt;' => '<' }
            lang = $1 || :text
            code = $2
            code.gsub!(/&(?:amp|quot|[gl]t);/) { |entity| replacements[entity] }
            Albino.colorize(code, lang)
          end
          # Prarse charpters
          if textile_options[:chapters]
            chapters = []
            html.gsub!(/(<h2>(.*)<\/h2>)/) do
              chapters << $2
              "<a name=\"#{self.class.label_for($2)}\">&nbsp;</a>\n" + $1
            end
            self.send("#{textile_field}_chapters=", chapters)
          end
          # Parse external links
          html.gsub!(/(<a href="(.*?)".*?)(>.*?<\/a>)/) do |link|
            tag_start, href, tag_end = $1, $2, $3
            link =~ /target/ || href =~ /^\/|^http:\/\/(www\.)?padrino/ ? link : "#{tag_start} target=\"_blank\"#{tag_end}"
          end
          # Parse internal links
          html.gsub!(/\[\[([^\]]+)\]\]/) do
            page, name = *$1.split("|") # this allow to rename link ex: [[Page Name|link me]]
            name ||= page
            "<a href=\"/#{textile_options[:internal_links]}/#{Post.permalink_for(page.strip)}\">#{name.strip}</a>"
          end
          # Write content
          self.send("#{textile_field}_html=", html)
        end
      end
  end # InstanceMethods
end # Permalink
MongoMapper::Document.send(:include, Textile)