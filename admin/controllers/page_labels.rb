Admin.controllers :page_labels do

  get :index do
    @page_labels = PageLabel.all
    render 'page_labels/index'
  end

  get :new do
    @page_label = PageLabel.new
    render 'page_labels/new'
  end

  post :create do
    @page_label = PageLabel.new(params[:page_label])
    if @page_label.save
      flash[:notice] = 'PageLabel was successfully created.'
      redirect url(:page_labels, :edit, :id => @page_label.id)
    else
      render 'page_labels/new'
    end
  end

  get :edit, :with => :id do
    @page_label = PageLabel.find(params[:id])
    render 'page_labels/edit'
  end

  put :update, :with => :id do
    @page_label = PageLabel.find(params[:id])
    if @page_label.update_attributes(params[:page_label])
      flash[:notice] = 'PageLabel was successfully updated.'
      redirect url(:page_labels, :edit, :id => @page_label.id)
    else
      render 'page_labels/edit'
    end
  end

  delete :destroy, :with => :id do
    page_label = PageLabel.find(params[:id])
    if page_label.destroy
      flash[:notice] = 'PageLabel was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy PageLabel!'
    end
    redirect url(:page_labels, :index)
  end
end