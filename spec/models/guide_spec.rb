require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "Guide Model" do

  before do
    Guide.collection.remove
    @account = Account.first || Account.create(:email => "foo@bar.it", :password => "foobar", :password_confirmation => "foobar")
  end

  it 'not create a guide without title' do
    guide = Guide.create
    guide.errors.size.should > 0
    Guide.count.should == 0
  end

  it 'not create a post without body' do
    guide = Post.create(:title => 'foo')
    guide.errors.size.should > 0
    Guide.count.should == 0
  end

  it 'be draft as default' do
    guide = Guide.create(:title => 'Foo', :summary => 'Bar', :author_id => @account.id)
    guide.draft.should be_true
  end

  context 'permalink' do
    it 'create a permalink' do
      guide = Guide.create(:title => '[Lorem] ipsum dolor sit amet, consectetur adipisicing-elit', :body => 'foo', :author_id => @account.id)
      guide.permalink.should == "lorem-ipsum-dolor-sit-amet-consectetur-adipisicing-elit"
    end

    it 'not create a permalink if title is not unique' do
      Guide.create(:title => '[Lorem] ipsum dolor sit amet, consectetur adipisicing-elit', :body => 'foo', :author_id => @account.id)
      guide = Guide.create(:title => '[Lorem] ipsum dolor sit amet, consectetur adipisicing-elit', :body => 'foo', :author_id => @account.id)
      guide.errors.size.should > 0
    end
  end

  context 'textile' do
    it 'create correctly the textile formatted for body' do
      guide = Guide.create(:title => 'Foo Bar', :body => 'h1. Lorem ipsum dolor sit amet, consectetur adipisicing elit', :author_id => @account.id)
      guide.body_formatted.should == '<h1>Lorem ipsum dolor sit amet, consectetur adipisicing elit</h1>'
    end

    it 'create correctly internal links' do
      linked = Guide.create(:title => 'Linked Page', :body => 'Im the linked page', :author_id => @account.id)
      linker = Guide.create(:title => 'Linker', :body => 'I should link to [[Linked Page]]', :author_id => @account.id)
      linker.body_formatted.should == '<p>I should link to <a href="/guides/linked-page">Linked Page</a></p>'
    end

    it 'not parse pre without lang' do
      guide = Guide.create(:title => 'Foo Bar', :body => '<pre>Lorem ipsum dolor sit amet, consectetur adipisicing elit</pre>', :author_id => @account.id)
      guide.body_formatted.should == "<div class=\"padrino-syntax\"><pre>Lorem ipsum dolor sit amet, consectetur adipisicing elit\n</pre></div>"
    end

    it 'parse correctly pre with lang' do
      guide = Guide.create(:title => 'Foo Bar', :body => '<pre lang="ruby">Lorem ipsum dolor sit amet, consectetur adipisicing elit</pre>', :author_id => @account.id)
      guide.body_formatted.should == "<div class=\"padrino-syntax\"><pre><span class=\"no\">Lorem</span> <span class=\"n\">ipsum</span> <span class=\"n\">dolor</span> <span class=\"n\">sit</span> <span class=\"n\">amet</span><span class=\"p\">,</span> <span class=\"n\">consectetur</span> <span class=\"n\">adipisicing</span> <span class=\"n\">elit</span>\n</pre></div>"
      guide = Guide.create(:title => 'Foo Baz', :body => 'pre[ruby]. Lorem ipsum dolor sit amet, consectetur adipisicing elit', :author_id => @account.id)
      guide.body_formatted.should == "<div class=\"padrino-syntax\"><pre><span class=\"no\">Lorem</span> <span class=\"n\">ipsum</span> <span class=\"n\">dolor</span> <span class=\"n\">sit</span> <span class=\"n\">amet</span><span class=\"p\">,</span> <span class=\"n\">consectetur</span> <span class=\"n\">adipisicing</span> <span class=\"n\">elit</span>\n</pre></div>"
    end

    it 'parse correctly chapters' do
      guide = Guide.create(:title => 'Foo Bar', :body => 'h2. Lorem ipsum dolor sit amet, consectetur adipisicing elit', :author_id => @account.id)
      guide.body_formatted.should == "<a name=\"lorem-ipsum-dolor-sit-amet-consectetur-adipisicing-elit\">&nbsp</a>\n<h2>Lorem ipsum dolor sit amet, consectetur adipisicing elit</h2>"
    end

    it 'can generate a diff' do
      guide = Guide.create(:title => 'Foo Bar', :body => 'h2. Lorem ipsum dolor sit amet, consectetur adipisicing elit', :author_id => @account.id)
      guide.body = "h3. foo"
      guide.diff(:body).should == "\n@@ -1,2 +1,2 @@\n-h2. Lorem ipsum dolor sit amet, consectetur adipisicing elit\n+h3. foo\n"
    end
  end
end
