PadrinoWeb.controllers :blog do

  get :index, :map => "/blog", :respond_to => [:html, :rss] do
    case content_type
      when :html
        options = { :order => "created_at desc", :page => (params[:page] || 1), :draft => false }
        if params[:q].present? && params[:q].size > 3
          re = Regexp.new(Regexp.escape(params[:q]), 'i').to_json
          options.merge!("$where" => "this.title.match(#{re}) || this.summary.match(#{re}) || this.body.match(#{re})")
          @search = params[:q]
        end
        @posts = Post.paginate(options)
        render 'blog/index'
      when :rss
        @posts = Post.all(:limit => 10, :draft => false, :order => "created_at desc")
        render 'blog/rss'
    end
  end

  get :show, :with => :id, :map => "/blog" do
    @post = Post.find_by_permalink(params[:id])
    render 'blog/show'
  end

  get :category, :with => :id, :map => "/blog/category" do
    @category = Category.find_by_permalink(params[:id])
    @posts = Post.paginate(:category_ids => @category.id, :order => "created_at desc", :page => (params[:page] || 1), :draft => false)
    render 'blog/index'
  end
end