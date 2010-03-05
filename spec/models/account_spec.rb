require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "Account Model" do

  before do
    @account = Account.first || Account.create(:email => "foo@bar.it", :password => "foobar", :role => 'admin', :password_confirmation => "foobar")
  end

  it 'have an account' do
    @account.valid?
    @account.errors.full_messages.should be_empty
  end

  it 'not create an account' do
    account = Account.create
    account.errors.full_messages.should include("Password confirmation can't be empty",
                                                "Role can't be empty",
                                                "Role is invalid",
                                                "Email can't be empty",
                                                "Email is invalid",
                                                "Email is invalid",
                                                "Password can't be empty",
                                                "Password is invalid")
  end

  it 'cannot be destroyed if has posts' do
    post = @account.posts.create(:title => 'Foo', :summary => 'Bar')
    @account.posts.should_not be_empty
    @account.destroy.should be_false
    @account.posts.should_not be_empty
  end

  it 'cannot be destroyed if has guides' do
    guide = @account.guides.create(:title => 'Foo', :body => 'Bar')
    @account.guides.should_not be_empty
    @account.destroy.should be_false
    @account.guides.should_not be_empty
  end

  it 'cannot be destroyed if has pages' do
    page = @account.pages.create(:title => 'Foo', :body => 'Bar', :label_name => 'Foo')
    @account.pages.should_not be_empty
    @account.destroy.should be_false
    @account.pages.should_not be_empty
  end

  it 'create correctly the textile formatted for description' do
    @account.description = 'h1. Lorem ipsum dolor sit amet, consectetur adipisicing elit'
    @account.save
    @account.description_html.should == '<h1>Lorem ipsum dolor sit amet, consectetur adipisicing elit</h1>'
  end

  it 'has gravatar' do
    @account.gravatar.should =~ /http:\/\/www.gravatar.com\/avatar\//
  end
end