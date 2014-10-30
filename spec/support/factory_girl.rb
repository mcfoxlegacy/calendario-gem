require 'taxcalendario/entities'
require 'taxcalendario/admin/client'
require 'yaml'

FactoryGirl.define do
  
  # Factory of Account API client
  factory :conta_service, class: Taxcalendario::Client::ContaService do
    access_token YAML::load(File.read("spec/test.yml"))[:token]
    base_url YAML::load(File.read("spec/test.yml"))[:base_url]
  end
  
  # Factory of Account API client
  factory :estabelecimento_service, class: Taxcalendario::Client::EstabelecimentoService do
    access_token YAML::load(File.read("spec/test.yml"))[:token]
    base_url YAML::load(File.read("spec/test.yml"))[:base_url]
  end
  
  # Factory of establishment object
  factory :estabelecimento, class: Taxcalendario::Client::Entities::Estabelecimento do
    nome              "Estabelecimento teste"
    cnpj              "12345698905432"
    ie                "3243254"
    cnaes             "34324324"
    uf                "SP"
    municipio         "SAO PAULO"
    dt_inicio         "2012-01-01"
    dt_fim            "2025-01-01"
    ie_sede           false
    apuracao_lucro    "real" 
    simples_nacional  false
    mei               false
  end
    
end