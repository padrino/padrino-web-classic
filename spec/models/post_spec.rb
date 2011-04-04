require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "Post Model" do

  before do
    Post.collection.remove
    @account = Account.first || Account.create(:email => "foo@bar.it", :password => "foobar", :password_confirmation => "foobar", :role => 'admin')
  end

  it 'not create a post without title' do
    post = @account.posts.create
    post.errors.size.should > 0
    @account.posts.count.should == 0
  end

  it 'not create a post without summary' do
    post = @account.posts.create(:title => 'foo')
    post.errors.size.should > 0
    Post.count.should == 0
  end

  it 'not create a post without author' do
    Post.create(:title => 'foo', :summary => 'bar')
    Post.count.should == 0
  end

  it 'be draft as default' do
    post = @account.posts.create(:title => 'Foo', :summary => 'Bar')
    post.draft.should be_true
  end

  context 'permalink' do
    it 'create a permalink' do
      post = @account.posts.create(:title => '[Lorem] ipsum dolor sit amet, consectetur adipisicing-elit', :summary => 'foo')
      post.permalink.should == "lorem-ipsum-dolor-sit-amet-consectetur-adipisicing-elit"
    end

    it 'not create a permalink if title is not unique' do
      @account.posts.create(:title => '[Lorem] ipsum dolor sit amet, consectetur adipisicing-elit', :summary => 'foo')
      post = @account.posts.create(:title => '[Lorem] ipsum dolor sit amet, consectetur adipisicing-elit', :summary => 'foo')
      post.errors.size.should > 0
    end
  end

  context 'textile' do
    it 'create correctly the textile formatted for body' do
      post = @account.posts.create(:title => 'Foo Bar', :summary => 'foo', :body => 'h1. Lorem ipsum dolor sit amet, consectetur adipisicing elit')
      post.body_html.should == '<h1>Lorem ipsum dolor sit amet, consectetur adipisicing elit</h1>'
    end

    it 'create correctly the textile formatted for summary' do
      post = @account.posts.create(:title => 'Foo Bar', :summary => 'h1. Lorem ipsum dolor sit amet, consectetur adipisicing elit')
      post.summary_html.should == '<h1>Lorem ipsum dolor sit amet, consectetur adipisicing elit</h1>'
    end

    it 'create correctly internal links' do
      linked = @account.posts.create(:title => 'Linked Page', :summary => 'Im the linked page')
      linker = @account.posts.create(:title => 'Linker', :summary => 'I should link to [[Linked Page]]')
      linker.summary_html.should == '<p>I should link to <a href="/blog/linked-page">Linked Page</a></p>'
    end

    it 'create correctly named internal links' do
      linked = @account.posts.create(:title => 'Linked Page', :summary => 'Im the linked page')
      linker = @account.posts.create(:title => 'Linker', :summary => 'I should link to [[Linked Page|Custom Name]]')
      linker.summary_html.should == '<p>I should link to <a href="/blog/linked-page">Custom Name</a></p>'
    end

    it 'not parse pre without lang' do
      post = @account.posts.create(:title => 'Foo Bar', :summary => '<pre>Lorem ipsum dolor sit amet, consectetur adipisicing elit</pre>')
      post.summary_html.should == "<div class=\"padrino-syntax\"><pre>Lorem ipsum dolor sit amet, consectetur adipisicing elit\n</pre></div>"
    end

    it 'parse correctly pre with lang' do
      post = @account.posts.create(:title => 'Foo Bar', :summary => '<pre lang="ruby">Lorem ipsum dolor sit amet, consectetur adipisicing elit</pre>')
      post.summary_html.should == "<div class=\"padrino-syntax\"><pre><span class=\"no\">Lorem</span> <span class=\"n\">ipsum</span> <span class=\"n\">dolor</span> <span class=\"n\">sit</span> <span class=\"n\">amet</span><span class=\"p\">,</span> <span class=\"n\">consectetur</span> <span class=\"n\">adipisicing</span> <span class=\"n\">elit</span>\n</pre></div>"
      post = @account.posts.create(:title => 'Foo Baz', :summary => 'pre[ruby]. Lorem ipsum dolor sit amet, consectetur adipisicing elit')
      post.summary_html.should == "<div class=\"padrino-syntax\"><pre><span class=\"no\">Lorem</span> <span class=\"n\">ipsum</span> <span class=\"n\">dolor</span> <span class=\"n\">sit</span> <span class=\"n\">amet</span><span class=\"p\">,</span> <span class=\"n\">consectetur</span> <span class=\"n\">adipisicing</span> <span class=\"n\">elit</span>\n</pre></div>"
      post = @account.posts.create(:title => 'Foo Bag', :summary => '<pre lang="ruby"><code>Lorem ipsum dolor sit amet, consectetur adipisicing elit</code></pre>')
      post.summary_html.should == "<div class=\"padrino-syntax\"><pre><span class=\"no\">Lorem</span> <span class=\"n\">ipsum</span> <span class=\"n\">dolor</span> <span class=\"n\">sit</span> <span class=\"n\">amet</span><span class=\"p\">,</span> <span class=\"n\">consectetur</span> <span class=\"n\">adipisicing</span> <span class=\"n\">elit</span>\n</pre></div>"
    end

    it 'parse correctly without lang' do
      post = @account.posts.create(:title => 'Foo Bar', :summary => '<pre>Lorem ipsum dolor sit amet, consectetur adipisicing elit</pre>')
      post.summary_html.should == "<div class=\"padrino-syntax\"><pre>Lorem ipsum dolor sit amet, consectetur adipisicing elit\n</pre></div>"
    end
  end

  context 'categories' do
    before do
      Category.delete_all
    end

    it 'associate correctly categories' do
      categories = %w(press news ruby).map { |name| Category.create(:name => name) }
      post = @account.posts.create(:title => 'Last News', :summary => "Last news")
      post.should_not be_nil
      post.categories.should be_empty
      post.categories = categories
      post.save
      post.categories.should == categories
      # Simulation of an html form
      post.should respond_to(:category_ids=)
      category_ids = categories.map { |c| c.id.to_s }.flatten
      category_ids << "0"
      post = @account.posts.create(:title => 'Last Blog News', :summary => "Last blog news", :category_ids => category_ids)
      post.should_not be_nil
      post.categories.should == categories
    end
  end

  context 'search' do
    before do
      @post_one   = @account.posts.create(:title => "One", :summary => "One summary", :body => "One body")
      @post_two   = @account.posts.create(:title => "Two", :summary => "Two summary", :body => "Two body")
      @post_three = @account.posts.create(:title => "Three", :summary => "Three summary", :body => "Three body")
    end

    it 'perform basic searches' do
      Post.search("one").should == [@post_one]
      Post.search("two").should == [@post_two]
      Post.search("three").should == [@post_three]
      Post.search("body").should include(@post_one, @post_two, @post_three)
      Post.search("summary").should include(@post_one, @post_two, @post_three)
    end

    it 'paginate correctly' do
      Post.search("one", :paginate => true, :per_page => 1).should == [@post_one]
    end
  end
end