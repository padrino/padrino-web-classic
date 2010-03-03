PadrinoWeb.controllers :guides do
  get :index, :map => "/guides" do
    @guide = Guide.find_by_title('Home')
    render 'guides/show'
  end

  get :show, :with => :id, :map => "/guides" do
    @guide = Guide.find_by_permalink(params[:id])
    render 'guides/show'
  end
end