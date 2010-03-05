require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "Category Model" do
  it 'can be created' do
    category = Category.new
    category.valid?.should be_false
    category.name = "Press"
    category.valid?.should be_true
    category.save.should be_true
  end

  it 'have a permalink' do
    category = Category.create(:name => 'Foo Bar')
    category.permalink.should == 'foo-bar'
  end

  it 'have some posts' do
    account = Account.first || Account.create(:email => "foo@bar.it", :password => "foobar", :role => 'admin', :password_confirmation => "foobar")
    category = Category.create(:name => 'Foo')
    category.posts.should be_empty
    post = Post.create(:title => 'Foo Bar', :summary => 'Foo Bar', :author_id => account.id)
    post.category_ids << category.id
    post.save
    category.posts.should == [post]
    category.post_count.should == 1
  end
end
