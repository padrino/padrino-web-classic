require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "Page Model" do

  before do
    Page.collection.remove
    @account = Account.first || Account.create(:email => "foo@bar.it", :password => "foobar", :password_confirmation => "foobar", :role => 'admin')
    @label = PageLabel.first || PageLabel.create(:name => 'Foo')
  end

  it 'not create a page without title' do
    page = @account.pages.create
    page.errors.size.should > 0
    @account.pages.count.should == 0
  end

  it 'not create a page without body' do
    page = Post.create(:title => 'foo')
    page.errors.size.should > 0
    Page.count.should == 0
  end

  it 'not create a page without author' do
    Page.create(:title => 'foo', :body => 'bar')
    Page.count.should == 0
  end

  it 'not create a page without label' do
    @account.pages.create(:title => 'Foo', :body => 'Bar')
    Page.count.should == 0
  end

  it 'be draft as default' do
    page = @account.pages.create(:title => 'Foo', :body => 'Bar', :label_id => @label.id)
    page.draft.should be_true
  end

  context 'permalink' do
    it 'create a permalink' do
      page = @account.pages.create(:title => '[Lorem] ipsum dolor sit amet, consectetur adipisicing-elit', :body => 'foo', :label_id => @label.id)
      page.permalink.should == "lorem-ipsum-dolor-sit-amet-consectetur-adipisicing-elit"
    end

    it 'not create a permalink if title is not unique' do
      @account.pages.create(:title => '[Lorem] ipsum dolor sit amet, consectetur adipisicing-elit', :body => 'foo', :label_id => @label.id)
      page = @account.pages.create(:title => '[Lorem] ipsum dolor sit amet, consectetur adipisicing-elit', :body => 'foo', :label_id => @label.id)
      page.errors.size.should > 0
    end
  end

  context 'textile' do
    it 'create correctly the textile formatted for body' do
      page = @account.pages.create(:title => 'Foo Bar', :body => 'h1. Lorem ipsum dolor sit amet, consectetur adipisicing elit', :label_id => @label.id)
      page.body_html.should == '<h1>Lorem ipsum dolor sit amet, consectetur adipisicing elit</h1>'
    end

    it 'create correctly internal links' do
      linked = @account.pages.create(:title => 'Linked Page', :body => 'Im the linked page', :label_id => @label.id)
      linker = @account.pages.create(:title => 'Linker', :body => 'I should link to [[Linked Page]]', :label_id => @label.id)
      linker.body_html.should == '<p>I should link to <a href="/pages/linked-page">Linked Page</a></p>'
    end

    it 'not parse pre without lang' do
      page = @account.pages.create(:title => 'Foo Bar', :body => '<pre>Lorem ipsum dolor sit amet, consectetur adipisicing elit</pre>', :label_id => @label.id)
      page.body_html.should == "<div class=\"padrino-syntax\"><pre>Lorem ipsum dolor sit amet, consectetur adipisicing elit\n</pre></div>"
    end

    it 'parse correctly pre with lang' do
      page = @account.pages.create(:title => 'Foo Bar', :body => '<pre lang="ruby">Lorem ipsum dolor sit amet, consectetur adipisicing elit</pre>', :label_id => @label.id)
      page.body_html.should == "<div class=\"padrino-syntax\"><pre><span class=\"no\">Lorem</span> <span class=\"n\">ipsum</span> <span class=\"n\">dolor</span> <span class=\"n\">sit</span> <span class=\"n\">amet</span><span class=\"p\">,</span> <span class=\"n\">consectetur</span> <span class=\"n\">adipisicing</span> <span class=\"n\">elit</span>\n</pre></div>"
      page = @account.pages.create(:title => 'Foo Baz', :body => 'pre[ruby]. Lorem ipsum dolor sit amet, consectetur adipisicing elit', :label_id => @label.id)
      page.body_html.should == "<div class=\"padrino-syntax\"><pre><span class=\"no\">Lorem</span> <span class=\"n\">ipsum</span> <span class=\"n\">dolor</span> <span class=\"n\">sit</span> <span class=\"n\">amet</span><span class=\"p\">,</span> <span class=\"n\">consectetur</span> <span class=\"n\">adipisicing</span> <span class=\"n\">elit</span>\n</pre></div>"
    end

    it 'can generate a diff' do
      page = @account.pages.create(:title => 'Foo Bar', :body => 'h2. Lorem ipsum dolor sit amet, consectetur adipisicing elit', :label_id => @label.id)
      page.body = "h3. foo"
      page.diff(:body).should == "\n@@ -1,2 +1,2 @@\n-h2. Lorem ipsum dolor sit amet, consectetur adipisicing elit\n+h3. foo\n"
    end

    it 'parse correctly chapters' do
      page = @account.pages.create(:title => 'Foo Bar', :body => 'h2. Lorem ipsum dolor sit amet, consectetur adipisicing elit', :label_id => @label.id)
      page.body_html.should == "<a name=\"lorem-ipsum-dolor-sit-amet-consectetur-adipisicing-elit\">&nbsp;</a>\n<h2>Lorem ipsum dolor sit amet, consectetur adipisicing elit</h2>"
    end
  end

  context 'label' do
    it 'must be unique' do
      label = PageLabel.create(:name => 'Bar')
      label.errors.size.should == 0
      label = PageLabel.create(:name => 'Bar')
      label.errors.size.should > 0
    end

    it 'cannot be destroyed if has pages' do
      page = @account.pages.create(:title => 'Foo Bar', :body => 'Lorem', :label_name => 'label')
      page.label.pages.should == [page]
      page.label.destroy
      PageLabel.find_by_name('label').should_not be_nil
    end

    it 'auto create a label' do
      page = @account.pages.create(:title => 'Foo Bar', :body => 'Lorem', :label_name => 'label')
      page.label.should_not be_nil
      page.label.name.should == 'label'
    end

    it 'reuse label if autogenerated and already exist' do
      page = @account.pages.create(:title => 'Foo Bar', :body => 'Lorem', :label_name => 'foo')
      page.label.should_not be_nil
      page.label.name.should == 'foo'
      @account.pages.create(:title => 'Foo Baz', :body => 'Lorem', :label_name => 'foo')
      page.label.should_not be_nil
      page.label.name.should == 'foo'
      PageLabel.find_all_by_name('foo').count.should == 1
    end

    it 'auto create a label with priority on label_id' do
      page = @account.pages.create(:label_name => 'bar', :title => 'Foo Bar', :body => 'Lorem', :label_id => @label.id)
      page.label.should_not be_nil
      page.label.name.should == 'bar'
      page = @account.pages.build(:title => 'Foo Baz', :body => 'Lorem')
      page.label_name = 'zar'
      page.label_id = @label.id
      page.save
      page.label.name.should == 'zar'
    end
  end

  context 'search' do
    before do
      @page_one   = @account.pages.create(:title => "One", :body => "One body", :label_name => "Foo")
      @page_two   = @account.pages.create(:title => "Two", :body => "Two body", :label_name => "Foo")
      @page_three = @account.pages.create(:title => "Three", :body => "Three body", :label_name => "Foo")
    end

    it 'perform basic searches' do
      Page.search("one").should == [@page_one]
      Page.search("two").should == [@page_two]
      Page.search("three").should == [@page_three]
      Page.search("body").should include(@page_one, @page_two, @page_three)
    end

    it 'paginate correctly' do
      Page.search("one", :paginate => true, :per_page => 1).should == [@page_one]
    end
  end
end