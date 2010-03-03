# Helper methods defined here can be accessed in any controller or view in the application
PadrinoWeb.helpers do
  def key_density(*words)
    words.join(" - ").concat(" - Padrino - Ruby Framework").gsub(/^ - /, '')
  end

  def title(*words)
    @_title = key_density(*words) if words.present?
    @_title
  end

  def description(text=nil)
    @_description = text if text.present?
    @_description || (<<-TXT).gsub(/ {8}/, '')
      Padrino is a ruby framework built upon the excellent Sinatra Microframework.
      This framework tries hard to make it as fun and easy as possible to code much more advanced web
      applications by building upon the Sinatra philosophies and foundation.
    TXT
  end

  def paginate_posts(collection)
    if collection.total_pages > Post.per_page
      html = 'Pages: ' + 1.upto(collection.total_pages).map { |i|
        options = { :page => i }
        options.merge!(:q => params[:q]) if params[:q].present?
        link_to(i, url(:blog, :index, options), :class => (params[:page].to_i == i ? :current : :page))
      }.join
    end
  end
end
