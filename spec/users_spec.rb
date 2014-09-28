require 'factory_girl'
require 'taxcalendario/client'
require 'support/factory_girl.rb'

# Include FactoryGirl module
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

# Test user API client
describe "User service API Client" do
  
  it "shoud return a list of user" do
    userapi = build(:user_service)
    lu = userapi.list
    lu.count > 0
  end
  
  it "shoud return the my id and my complete register" do
    userapi = build(:user_service)
    id = userapi.meu_id
    reg = userapi.get(id)
    reg.email != nil
  end
end