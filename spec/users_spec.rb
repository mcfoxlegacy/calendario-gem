require 'taxcalendario/client'
describe "User service API Client" do
  it "shoud return a list of user" do
    userapi = Taxcalendario::Client::UserService.new
    userapi.set_access_token("b87bd510368c438de6c9d6392bce1669")
    lu = userapi.list
    lu.each do |user|
      puts user.name
    end
    lu.count > 0
  end
  
  it "shoud return the id of token user" do
    userapi = Taxcalendario::Client::UserService.new
    userapi.set_access_token("b87bd510368c438de6c9d6392bce1669")
    i = userapi.meu_id
    puts "My id is #{i.to_s}"
    i > 0
  end
end