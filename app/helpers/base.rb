# Helper methods defined here can be accessed in any controller or view in the application
PadrinoWeb.helpers do
  def key_density(*words)
    words.compact.join(" ").concat(" - Padrino Ruby Web Framework").gsub(/^ - /, '')
  end

  def title(*words)
    @_title = key_density(*words) if words.present?
    @_title
  end

  def description(text=nil)
    @_description = truncate(text.gsub(/<\/?[^>]*>/, '').gsub(/\n/, ' ').strip, :length => 355) if text.present?
    @_description || (<<-TXT).gsub(/ {6}/, '').gsub(/\n/, ' ').strip
      Padrino is a ruby framework built upon the excellent Sinatra Microframework.
      This framework tries hard to make it as fun and easy as possible to code much more advanced web
      applications by building upon the Sinatra philosophies and foundation.
    TXT
  end

  def paginate(collection, controller, action)
    return if collection.empty?
    if collection.total_pages > collection.per_page
      html = 'Pages: ' + 1.upto(collection.total_pages).map { |i|
        options = { :page => i }
        options.merge!(:q => params[:q]) if params[:q].present?
        link_to(i, url(controller, action, options), :class => (params[:page].to_i == i ? :current : :page))
      }.join
    end
  end
end
