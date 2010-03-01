Admin.controllers :guides do

  get :index do
    @guides = Guide.all
    render 'guides/index'
  end

  get :new do
    @guide = Guide.new
    render 'guides/new'
  end

  post :create do
    @guide = Guide.new(params[:guide])
    if @guide.save
      flash[:notice] = 'Guide was successfully created.'
      redirect url(:guides, :edit, :id => @guide.id)
    else
      render 'guides/new'
    end
  end

  get :edit, :with => :id do
    @guide = Guide.find(params[:id])
    render 'guides/edit'
  end

  put :update, :with => :id do
    @guide = Guide.find(params[:id])
    if @guide.update_attributes(params[:guide])
      flash[:notice] = 'Guide was successfully updated.'
      redirect url(:guides, :edit, :id => @guide.id)
    else
      render 'guides/edit'
    end
  end

  delete :destroy, :with => :id do
    guide = Guide.find(params[:id])
    if guide.destroy
      flash[:notice] = 'Guide was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Guide!'
    end
    redirect url(:guides, :index)
  end
end