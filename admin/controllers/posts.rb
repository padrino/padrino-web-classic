Admin.controllers :posts do

  get :index do
    @posts = Post.all(:order => 'created_at desc')
    render 'posts/index'
  end

  get :new do
    @post = Post.new
    render 'posts/new'
  end

  post :create do
    @post = Post.new(params[:post].merge(:author_id => current_account.id))
    if @post.save
      flash[:notice] = 'Post was successfully created.'
      redirect url(:posts, :edit, :id => @post.id)
    else
      render 'posts/new'
    end
  end

  get :edit, :with => :id do
    @post = Post.find(params[:id])
    render 'posts/edit'
  end

  put :update, :with => :id do
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post].merge(:author_id => current_account.id))
      flash[:notice] = 'Post was successfully updated.'
      redirect url(:posts, :edit, :id => @post.id)
    else
      render 'posts/edit'
    end
  end

  delete :destroy, :with => :id do
    post = Post.find(params[:id])
    if post.destroy
      flash[:notice] = 'Post was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Post!'
    end
    redirect url(:posts, :index)
  end
end