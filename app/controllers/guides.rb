PadrinoWeb.controllers :guides do
  get :search, :map => "/guides/search" do
    if params[:q] && params[:q].size >= 4
      @search  = params[:q]
      @guides  = Guide.search(@search, :order => "updated_at desc", :page => (params[:page] || 1), :draft => false, :paginate => true)
    end
    render 'guides/index'
  end

  get :index, :map => "/guides" do
    @guide = Guide.find_by_title('Home')
    render 'guides/show'
  end

  get :show, :with => :id, :map => "/guides" do
    @guide = Guide.find_by_permalink(params[:id])
    render 'guides/show'
  end
end