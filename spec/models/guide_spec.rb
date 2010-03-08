require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "Guide Model" do

  before do
    Guide.collection.remove
    @account = Account.first || Account.create(:email => "foo@bar.it", :password => "foobar", :password_confirmation => "foobar", :role => 'admin')
  end

  it 'not create a guide without title' do
    guide = @account.guides.create
    guide.errors.size.should > 0
    @account.guides.count.should == 0
  end

  it 'not create a guide without body' do
    guide = Guide.create(:title => 'foo')
    guide.errors.size.should > 0
    Guide.count.should == 0
  end

  it 'not create a guide without author' do
    Guide.create(:title => 'foo', :body => 'bar')
    Guide.count.should == 0
  end

  it 'be draft as default' do
    guide = @account.guides.create(:title => 'Foo', :body => 'Bar')
    guide.draft.should be_true
  end

  context 'permalink' do
    it 'create a permalink' do
      guide = @account.guides.create(:title => '[Lorem] ipsum dolor sit amet, consectetur adipisicing-elit', :body => 'foo')
      guide.permalink.should == "lorem-ipsum-dolor-sit-amet-consectetur-adipisicing-elit"
    end

    it 'not create a permalink if title is not unique' do
      @account.guides.create(:title => '[Lorem] ipsum dolor sit amet, consectetur adipisicing-elit', :body => 'foo')
      guide = @account.guides.create(:title => '[Lorem] ipsum dolor sit amet, consectetur adipisicing-elit', :body => 'foo')
      guide.errors.size.should > 0
    end
  end

  context 'textile' do
    it 'create correctly the textile formatted for body' do
      guide = @account.guides.create(:title => 'Foo Bar', :body => 'h1. Lorem ipsum dolor sit amet, consectetur adipisicing elit')
      guide.body_html.should == '<h1>Lorem ipsum dolor sit amet, consectetur adipisicing elit</h1>'
    end

    it 'create correctly internal links' do
      linked = @account.guides.create(:title => 'Linked Page', :body => 'Im the linked page')
      linker = @account.guides.create(:title => 'Linker', :body => 'I should link to [[Linked Page]]')
      linker.body_html.should == '<p>I should link to <a href="/guides/linked-page">Linked Page</a></p>'
    end

    it 'not parse pre without lang' do
      guide = @account.guides.create(:title => 'Foo Bar', :body => '<pre>Lorem ipsum dolor sit amet, consectetur adipisicing elit</pre>')
      guide.body_html.should == "<div class=\"padrino-syntax\"><pre>Lorem ipsum dolor sit amet, consectetur adipisicing elit\n</pre></div>"
    end

    it 'parse correctly pre with lang' do
      guide = @account.guides.create(:title => 'Foo Bar', :body => '<pre lang="ruby">Lorem ipsum dolor sit amet, consectetur adipisicing elit</pre>')
      guide.body_html.should == "<div class=\"padrino-syntax\"><pre><span class=\"no\">Lorem</span> <span class=\"n\">ipsum</span> <span class=\"n\">dolor</span> <span class=\"n\">sit</span> <span class=\"n\">amet</span><span class=\"p\">,</span> <span class=\"n\">consectetur</span> <span class=\"n\">adipisicing</span> <span class=\"n\">elit</span>\n</pre></div>"
      guide = @account.guides.create(:title => 'Foo Baz', :body => 'pre[ruby]. Lorem ipsum dolor sit amet, consectetur adipisicing elit')
      guide.body_html.should == "<div class=\"padrino-syntax\"><pre><span class=\"no\">Lorem</span> <span class=\"n\">ipsum</span> <span class=\"n\">dolor</span> <span class=\"n\">sit</span> <span class=\"n\">amet</span><span class=\"p\">,</span> <span class=\"n\">consectetur</span> <span class=\"n\">adipisicing</span> <span class=\"n\">elit</span>\n</pre></div>"
    end

    it 'parse correctly chapters' do
      guide = @account.guides.create(:title => 'Foo Bar', :body => 'h2. Lorem ipsum dolor sit amet, consectetur adipisicing elit')
      guide.body_html.should == "<a name=\"lorem-ipsum-dolor-sit-amet-consectetur-adipisicing-elit\">&nbsp;</a>\n<h2>Lorem ipsum dolor sit amet, consectetur adipisicing elit</h2>"
    end

    it 'can generate a diff' do
      guide = @account.guides.create(:title => 'Foo Bar', :body => 'h2. Lorem ipsum dolor sit amet, consectetur adipisicing elit')
      guide.body = "h3. foo"
      guide.diff(:body).should == "\n@@ -1,2 +1,2 @@\n-h2. Lorem ipsum dolor sit amet, consectetur adipisicing elit\n+h3. foo\n"
    end

    it 'can apply correctly target blank' do
      links = <<-HTML
        Lorem ipsum dolor sit amet, consectetur <a href="http://padrinorb.com">adipisicing</a> elit, 
        sed do eiusmod tempor <a href="http://external">incididunt</a> ut labore et dolore magna aliqua. 
        Ut enim ad minim veniam, quis <a href="http://www.padrinorb.org">nostrud</a> exercitation 
        ullamco laboris nisi ut <a href="http://padrino.lipsiasoft.biz">aliquip</a> ex ea commodo consequat.
        sed do eiusmod tempor <a href="http://foo.local" target="custom">incididunt</a> ut labore et dolore magna aliqua. 
        Ut enim ad minim veniam, quis <a href="http://www.yes.org" class="special">nostrud</a> exercitation 
        Lorem ipsum dolor sit amet, consectetur <a href="/internal/page">adipisicing</a> elit, 
      HTML
      guide = @account.guides.create(:title => 'Foo Bar', :body => links)
      guide.body_html.should =~ /<a href="http:\/\/padrinorb.com">adipisicing<\/a>/
      guide.body_html.should =~ /<a href="http:\/\/external" target="_blank">/
      guide.body_html.should =~ /<a href="http:\/\/www.padrinorb.org">nostrud<\/a>/
      guide.body_html.should =~ /<a href="http:\/\/padrino.lipsiasoft.biz">aliquip<\/a>/
      guide.body_html.should =~ /<a href="http:\/\/foo.local" target="custom">incididunt<\/a>/
      guide.body_html.should =~ /<a href="http:\/\/www.yes.org" class="special" target="_blank">nostrud<\/a>/
      guide.body_html.should =~ /<a href="\/internal\/page">adipisicing<\/a>/
    end
  end

  context 'search' do
    before do
      @guide_one   = @account.guides.create(:title => "One", :body => "One body", :label_name => "Foo")
      @guide_two   = @account.guides.create(:title => "Two", :body => "Two body", :label_name => "Foo")
      @guide_three = @account.guides.create(:title => "Three", :body => "Three body", :label_name => "Foo")
    end

    it 'perform basic searches' do
      Guide.search("one").should == [@guide_one]
      Guide.search("two").should == [@guide_two]
      Guide.search("three").should == [@guide_three]
      Guide.search("body").should include(@guide_one, @guide_two, @guide_three)
    end

    it 'paginate correctly' do
      Guide.search("one", :paginate => true, :per_page => 1).should == [@guide_one]
    end
  end
end