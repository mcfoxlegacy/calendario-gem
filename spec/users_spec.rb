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
  
  it "shoud don't create a new user because this not include a account" do
    userapi = build(:user_service)
    user = build(:user)
    begin
      nu = userapi.add(user)
      nu.id == nil
    rescue
      true
    end
  end
  
  it "shoud create an user" do
    userapi = build(:user_service)
    user = build(:user)
    
    conta_id = nil
    userapi.contas.each do |conta|
      conta_id = conta.id
      if conta_id != nil
        break
      end
    end
    user.conta_id = conta_id
    nu = userapi.add(user)
  end
  
  it "shoud update the previosly created user" do
    userapi = build(:user_service)
    list_users = userapi.list_by_email(build(:user).email)
    list_users[0].role = 1
    nu = userapi.update(list_users[0])
    nu.role == 1
  end
  
  it "shoud delete the previosly created user" do
    userapi = build(:user_service)
    list_users = userapi.list_by_email(build(:user).email)
    userapi.delete(list_users[0])
    list_users = userapi.list_by_email(build(:user).email)
    list_users.empty?
  end
  
end