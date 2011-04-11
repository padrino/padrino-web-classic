PadrinoWeb.controllers :guides, :cache => true do

  get :search, :map => "/guides/search", :cache => false do
    if params[:q] && params[:q].size >= 4
      @search  = params[:q]
      @guides  = Guide.search(@search, :order => "position", :page => (params[:page] || 1), :draft => false, :paginate => true)
    end
    render 'guides/index'
  end

  get :index, :map => "/guides" do
    @guide = Guide.find_by_title('Home')
    not_found unless @guide
    render 'guides/show'
  end

  get :show, :with => :id, :map => "/guides" do
    @guide = Guide.find_by_permalink(params[:id])
    not_found unless @guide
    render 'guides/show'
  end

  get :book, :provides => :pdf do
    content_type :pdf
    @guides  = Guide.all(:order => "position")
    html     = render 'guides/book', :layout => false
    html.gsub!(/href="/, "href=\"http://www.padrinorb.com")
    kit      = PDFKit.new(html, "footer-right" => "Page [page] of [toPage]",
                                "header-right" => "Padrino Framework v.#{Padrino.version} Book",
                                "disable-internal-links" => false,
                                "disable-external-links" => false)

    %w(reset text highlighter padrino).each do |style|
      kit.stylesheets << Padrino.root("public", "stylesheets", "#{style}.css")
    end
    kit.to_pdf
  end
end