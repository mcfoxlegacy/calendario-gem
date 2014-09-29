require 'taxcalendario/entities'
require 'taxcalendario/client'

FactoryGirl.define do
  
  # Factory of User API client
  factory :user_service, class: Taxcalendario::Client::UserService do
    access_token "5bca3fb811728b1da47f2dc0167bec3d" 
  end
  
    # Factory of Account API client
  factory :conta_service, class: Taxcalendario::Client::ContaService do
    access_token "5bca3fb811728b1da47f2dc0167bec3d" 
  end
  
  # Factory of User entity
  factory :user, class: Taxcalendario::Client::Entities::User do
    email "testerspec@gem-taxcalendario-client.com.br"
    name  "Teste RSpec"
    password "testerspec2015"
    role  2
  end
  
  # Factory of Establishment entity
  factory :estabelecimento, class: Taxcalendario::Client::Entities::Estabelecimento do
      nome              "Estabelecimento teste"
      cnpj              "12345678905432"
      ie                "3243254"
      cnaes             "34324324"
      uf                "SP"
      municipio         "SAO PAULO"
      dt_inicio         "2012-01-01"
      dt_fim            "2025-01-01"
      ie_sede           false
      apuracao_lucro    "REAL" 
      simples_nacional  false
      mei               false
  end
    
end