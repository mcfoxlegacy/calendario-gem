require 'factory_girl'
require 'taxcalendario/client'
require 'support/factory_girl.rb'

# Include FactoryGirl module
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

describe "Accounts service API Client" do
  
  it "should return my account" do
    contaapi = build(:conta_service)
    lc = contaapi.minha
    expect(lc.nome).not_to eq (nil)
  end
  
  it "should return my deliveries" do
    contaapi = build(:conta_service)
    dt_inicio = Time.now
    dt_fim = Time.now + (31 * 24 * 60 * 60)
    lc = contaapi.entregas(dt_inicio,dt_fim)
    expect(lc[0].estabelecimento.nome).not_to eq (nil)
    expect(lc[0].obrigacao.nome).not_to eq (nil)
  end
  
  it "should upload file to server" do
    contaapi = build(:conta_service)
    rtn = false
    begin
      contaapi.arquivo(__FILE__)
    rescue RuntimeError => e
      rtn = (e == "Nao foi possivel criar ou localizar a entrega desse arquivo.")
    end
    expect(rtn).not_to eq (true)
  end
  
end