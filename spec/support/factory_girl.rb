require 'taxcalendario/client'

FactoryGirl.define do
  factory :user_service, class: Taxcalendario::Client::UserService do
    access_token "5bca3fb811728b1da47f2dc0167bec3d" 
  end
end