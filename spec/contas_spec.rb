require 'factory_girl'
require 'taxcalendario/client'
require 'support/factory_girl.rb'

# Include FactoryGirl module
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

describe "Accounts service API Client" do
  
  it "shoud return a list of accounts" do
    contaapi = build(:conta_service)
    lc = contaapi.list
    expect(lc[0].responsavel_user_id).not_to eq (nil)
    expect(lc[0].responsavel_user_id).to be > 0 
  end
  
  it "shoud return a register by account id" do
    contaapi = build(:conta_service)
    lc = contaapi.list
    expect(contaapi.get(lc[0].id).id).to be > 0
  end
  
  it "return the users list from an account" do
    contaapi = build(:conta_service)
    userapi = build(:user_service)
    ok = false
    userapi.contas.each do |conta|
      users = contaapi.users_list(conta.id)
      expect(users.count).to be > 0
      ok = true
      break
    end
    expect(ok).to eq (true)
  end
  
  it "shoud create an user and add to account" do
    userapi = build(:user_service)
    contaapi = build(:conta_service)
    
    conta_id = userapi.contas[0].id
    
    ok = false
    contaapi.users_list(conta_id).each do |u|
      ok = u.id == userapi.meu_id
      if ok 
        break
      end
    end
    
    expect(ok).to eq (true)
  end
  
  it "should add an establishment" do
    contaapi = build(:conta_service)
    estabelecimento = build(:estabelecimento)
    estabelecimento.conta_id = contaapi.list[0].id
    retorno = contaapi.add_estabelecimento(estabelecimento)
    expect(retorno.id).not_to eq (nil)
  end
  
  it "should list and update the previosly created establishment" do
    contaapi = build(:conta_service)
    estabelecimento_ref = build(:estabelecimento)
    retorno = nil
    contaapi.estabelecimentos(contaapi.list[0].id).each do |est|
      if est.cnpj == estabelecimento_ref.cnpj
        est.mei = true
        retorno = contaapi.update_estabelecimento(est)
        break
      end
    end
    expect(retorno.mei).to eq (true)
  end
  
  it "should list and delete the previosly created establishment" do
    contaapi = build(:conta_service)
    estabelecimento_ref = build(:estabelecimento)
    retorno = false
    contaapi.estabelecimentos(contaapi.list[0].id).each do |est|
      if est.cnpj == estabelecimento_ref.cnpj
        contaapi.delete_estabelecimento(est)
        retorno = true
        break
      end
    end
    expect(retorno).to eq (true)
  end
  
  it "should returns a array of responsabilities" do
    #TODO: Test with data
    userapi = build(:user_service)
    contaapi = build(:conta_service)
    contaapi.responsabilidades(contaapi.list[0].id,userapi.meu_id)
  end
  
end