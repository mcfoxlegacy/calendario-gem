require 'taxcalendario/entities'
require 'taxcalendario/client'

FactoryGirl.define do
  
  # Factory of API
  factory :user_service, class: Taxcalendario::Client::UserService do
    access_token "5bca3fb811728b1da47f2dc0167bec3d" 
  end
  
  # Factory of User entity
  factory :user, class: Taxcalendario::Client::Entities::User do
    email "testerspec@gem-taxcalendario-client.com.br"
    name  "Teste RSpec"
    password "testerspec2015"
    role  2
  end
    
end