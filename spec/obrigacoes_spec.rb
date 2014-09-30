require 'factory_girl'
require 'taxcalendario/client'
require 'support/factory_girl.rb'

# Include FactoryGirl module
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

# Test obrigacao API client
describe "Obrigacao service API Client" do
  
  it "shoud create an obrigacao" do
    obrigacaoapi = build(:obrigacao_service)
    obrigacao = build(:obrigacao)
    no = obrigacaoapi.add(obrigacao)
    expect(no.id).not_to eq (nil)
  end
  
  it "shoud update the previosly created obrigacao" do
    obrigacaoapi = build(:obrigacao_service)
    list_obrigacaos = obrigacaoapi.list_by_nome(build(:obrigacao).nome)
    list_obrigacaos[0].msaf_codigo = "MSAF2.EXE"
    no = obrigacaoapi.update(list_obrigacaos[0])
    expect(no.msaf_codigo).to eq ("MSAF2.EXE")
  end
  
  it "shoud delete the previosly created obrigacao" do
    obrigacaoapi = build(:obrigacao_service)
    list_obrigacaos = obrigacaoapi.list_by_nome(build(:obrigacao).nome)
    list_obrigacaos.each do |ob|
      obrigacaoapi.delete(ob)
    end
    list_obrigacaos = obrigacaoapi.list_by_nome(build(:obrigacao).nome)
    expect(list_obrigacaos.empty?).to eq (true)
  end
   
end