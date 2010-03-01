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
end
