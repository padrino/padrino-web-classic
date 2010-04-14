PadrinoWeb.controllers :blog do

  get :index, :map => "/blog" do
    @search = params[:q] if params[:q] && params[:q].size >= 4
    @posts  = Post.search(@search, :order => "created_at desc", :page => (params[:page] || 1), :draft => false, :paginate => true)
    render 'blog/index'
  end

  get :rss, :map => "/blog", :respond_to => :rss do
    @posts = Post.all(:limit => 10, :draft => false, :order => "created_at desc")
    render 'blog/rss'
  end

  get :show, :with => :id, :map => "/blog" do
    @post = Post.find_by_permalink(params[:id])
    not_found unless @post
    render 'blog/show'
  end

  get :category, :with => :id, :map => "/blog/category" do
    @category = Category.find_by_permalink(params[:id])
    @posts = Post.paginate(:category_ids => @category.id, :order => "created_at desc", :page => (params[:page] || 1), :draft => false)
    render 'blog/index'
  end
end
