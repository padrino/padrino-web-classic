require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "Account Model" do

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
    account = Account.first || Account.create(:name => 'Foo', :password => 'foobar', :password_confirmation => 'foobar')
    post = account.posts.create(:title => 'Foo', :summary => 'Bar')
    account.posts.should_not be_empty
    account.destroy.should be_false
    account.posts.should_not be_empty
  end

  it 'cannot be destroyed if has guides' do
    account = Account.first || Account.create(:name => 'Foo', :password => 'foobar', :password_confirmation => 'foobar')
    guide = account.guides.create(:title => 'Foo', :body => 'Bar')
    account.guides.should_not be_empty
    account.destroy.should be_false
    account.guides.should_not be_empty
  end

  it 'cannot be destroyed if has pages' do
    account = Account.first || Account.create(:name => 'Foo', :password => 'foobar', :password_confirmation => 'foobar')
    page = account.pages.create(:title => 'Foo', :body => 'Bar', :label_name => 'Foo')
    account.pages.should_not be_empty
    account.destroy.should be_false
    account.pages.should_not be_empty
  end
end
