PadrinoWeb.controllers :pages, :cache => true do

  get :search, :map => "/pages/search", :cache => false do
    if params[:q] && params[:q].size >= 4
      @search = params[:q]
      label   = PageLabel.find_by_name("Menu")
      @pages  = Page.search(@search, :order => "position", :page => (params[:page] || 1), :draft => false, :paginate => true, :label_id => label.try(:id))
    end
    render 'pages/index'
  end

  get :show, :with => :id, :map => "/pages" do
    @page = Page.find_by_permalink(params[:id])
    not_found unless @page
    render 'pages/show'
  end
end