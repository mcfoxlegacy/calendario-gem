require 'taxcalendario/entities'
require 'taxcalendario/client'
require 'yaml'

FactoryGirl.define do
  
  # Factory of User API client
  factory :user_service, class: Taxcalendario::Client::UserService do
    access_token YAML::load(File.read("spec/token.yml"))[:token]
  end
  
  # Factory of Obrigacao API client
  factory :obrigacao_service, class: Taxcalendario::Client::ObrigacaoService do
    access_token YAML::load(File.read("spec/token.yml"))[:token] 
  end
  
  # Factory of Account API client
  factory :conta_service, class: Taxcalendario::Client::ContaService do
    access_token YAML::load(File.read("spec/token.yml"))[:token]
  end
  
  # Factory of User entity
  factory :user, class: Taxcalendario::Client::Entities::User do
    email "testerspec@gem-taxcalendario-client.com.br"
    name  "Teste RSpec"
    password "testerspec2015"
    role  2
  end
  
  # Factory of Entrega entity
  factory :entrega, class: Taxcalendario::Client::Entities::Entrega do
     competencia  "ABCDEFGH"
     dt_prevista  "2014-06-04"
     dt_entrega   "2014-07-04"
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
  
    # Factory of Establishment entity
  factory :obrigacao, class: Taxcalendario::Client::Entities::Obrigacao do  
      nome                              "Nome da obrigacao"
      descricao                         "Descricao da obrigacao"
      periodicidade                     "MENSAL"
      obrigatoriedade                   "Texto da obrigatoriedade"
      ambito                            "FEDERAL"
      legislacao                        "Texto da legislacao"
      entrega_por_dia_util              true
      posterga_em_dia_nao_util          true
      dia_entrega                       10
      meses_entrega                     9
      meses_defasagem_competencia       1
      cnaes                             "34324324"
      apuracao_lucro                    "REAL" 
      exigido_para_simples_nacional     true
      exigido_para_mei                  true
      estados                           "*"
      municipios                        "*"
      dt_fim                            "2025-01-01"
      dt_inicio                         "2012-01-01"
      msaf_codigo                       "SAFX.EXE"
  end
    
    
end