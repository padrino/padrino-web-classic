require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "Post Model" do

  before do
    Post.collection.remove
  end

  it 'not create a post without title' do
    post = Post.create
    post.errors.size.should > 0
    Post.count.should == 0
  end

  it 'not create a post without summary' do
    post = Post.create(:title => 'foo')
    post.errors.size.should > 0
    Post.count.should == 0
  end

  it 'be draft as default' do
    post = Post.create(:title => 'Foo', :summary => 'Bar')
    post.draft.should be_true
  end

  context 'permalink' do
    it 'create a permalink' do
      post = Post.create(:title => '[Lorem] ipsum dolor sit amet, consectetur adipisicing-elit', :summary => 'foo')
      post.permalink.should == "lorem-ipsum-dolor-sit-amet-consectetur-adipisicing-elit"
    end

    it 'not create a permalink if title is not unique' do
      Post.create(:title => '[Lorem] ipsum dolor sit amet, consectetur adipisicing-elit', :summary => 'foo')
      post = Post.create(:title => '[Lorem] ipsum dolor sit amet, consectetur adipisicing-elit', :summary => 'foo')
      post.errors.size.should > 0
    end
  end

  context 'textile' do
    it 'create correctly the textile formatted for body' do
      post = Post.create(:title => 'Foo Bar', :summary => 'foo', :body => 'h1. Lorem ipsum dolor sit amet, consectetur adipisicing elit')
      post.body_formatted.should == '<h1>Lorem ipsum dolor sit amet, consectetur adipisicing elit</h1>'
    end

    it 'create correctly the textile formatted for summary' do
      post = Post.create(:title => 'Foo Bar', :summary => 'h1. Lorem ipsum dolor sit amet, consectetur adipisicing elit')
      post.summary_formatted.should == '<h1>Lorem ipsum dolor sit amet, consectetur adipisicing elit</h1>'
    end

    it 'create correctly internal links' do
      linked = Post.create(:title => 'Linked Page', :summary => 'Im the linked page')
      linker = Post.create(:title => 'Linker', :summary => 'I should link to [[Linked Page]]')
      linker.summary_formatted.should == '<p>I should link to <a href="/blog/linked-page">Linked Page</a></p>'
    end

    it 'create correctly named internal links' do
      linked = Post.create(:title => 'Linked Page', :summary => 'Im the linked page')
      linker = Post.create(:title => 'Linker', :summary => 'I should link to [[Linked Page|Custom Name]]')
      linker.summary_formatted.should == '<p>I should link to <a href="/blog/linked-page">Custom Name</a></p>'
    end

    it 'not parse pre without lang' do
      post = Post.create(:title => 'Foo Bar', :summary => '<pre>Lorem ipsum dolor sit amet, consectetur adipisicing elit</pre>')
      post.summary_formatted.should == '<pre>Lorem ipsum dolor sit amet, consectetur adipisicing elit</pre>'
    end

    it 'parse correctly pre with lang' do
      post = Post.create(:title => 'Foo Bar', :summary => '<pre lang="ruby">Lorem ipsum dolor sit amet, consectetur adipisicing elit</pre>')
      post.summary_formatted.should == "<div class=\"padrino-syntax\"><pre><span class=\"no\">Lorem</span> <span class=\"n\">ipsum</span> <span class=\"n\">dolor</span> <span class=\"n\">sit</span> <span class=\"n\">amet</span><span class=\"p\">,</span> <span class=\"n\">consectetur</span> <span class=\"n\">adipisicing</span> <span class=\"n\">elit</span>\n</pre></div>"
      post = Post.create(:title => 'Foo Baz', :summary => 'pre[ruby]. Lorem ipsum dolor sit amet, consectetur adipisicing elit')
      post.summary_formatted.should == "<div class=\"padrino-syntax\"><pre><span class=\"no\">Lorem</span> <span class=\"n\">ipsum</span> <span class=\"n\">dolor</span> <span class=\"n\">sit</span> <span class=\"n\">amet</span><span class=\"p\">,</span> <span class=\"n\">consectetur</span> <span class=\"n\">adipisicing</span> <span class=\"n\">elit</span>\n</pre></div>"
      post = Post.create(:title => 'Foo Bag', :summary => '<pre lang="ruby"><code>Lorem ipsum dolor sit amet, consectetur adipisicing elit</code></pre>')
      post.summary_formatted.should == "<div class=\"padrino-syntax\"><pre><span class=\"no\">Lorem</span> <span class=\"n\">ipsum</span> <span class=\"n\">dolor</span> <span class=\"n\">sit</span> <span class=\"n\">amet</span><span class=\"p\">,</span> <span class=\"n\">consectetur</span> <span class=\"n\">adipisicing</span> <span class=\"n\">elit</span>\n</pre></div>"
    end
  end

  context "categories" do
    it "associate correctly categories" do
      categories = %w(press news ruby).map { |name| Category.create(:name => name) }
      post = Post.create(:title => 'Last News', :summary => "Last news")
      post.should_not be_nil
      post.categories = categories
      post.save
      post.categories.should == categories
      post = Post.create(:title => 'Last Blog News', :summary => "Last blog news", :category_ids => categories.map(&:id).flatten)
      post.should_not be_nil
      post.categories.should == categories
    end
  end
end
