PadrinoWeb.controllers :pages do
  get :show, :with => :id, :map => "/pages" do
    @page = Page.find_by_permalink(params[:id])
    render 'pages/show'
  end
end