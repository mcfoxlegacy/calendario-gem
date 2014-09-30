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
    
  it "shoud create an obrigacao" do
    obrigacaoapi = build(:obrigacao_service)
    obrigacao = build(:obrigacao)
    no = obrigacaoapi.add(obrigacao)
    expect(no.id).not_to eq (nil)
  end
  
  it "should add an obrigacao on establishment" do
    obrigacaoapi = build(:obrigacao_service)
    obrigacao_id = obrigacaoapi.list_by_nome(build(:obrigacao).nome)[0].id
    
    contaapi = build(:conta_service)
    conta_id = contaapi.list[0].id
    estabelecimento_id = contaapi.estabelecimentos(conta_id)[0].id
    
  
    dia_entrega=10;   
    
    retorno = contaapi.add_obrigacao(conta_id, estabelecimento_id, obrigacao_id, dia_entrega) 
    expect(retorno.id).not_to eq (nil)
  end
  
  it "should add an responsabilidade on establishment" do
    obrigacaoapi = build(:obrigacao_service)
    obrigacao_id = obrigacaoapi.list_by_nome(build(:obrigacao).nome)[0].id
        
    contaapi = build(:conta_service)
    conta_id = contaapi.list[0].id
    estabelecimento_id = contaapi.estabelecimentos(conta_id)[0].id
    
    userapi = build(:user_service)  
    user_id = userapi.meu_id
    
    responsabilidade = build(:responsabilidade)
    responsabilidade.estabelecimento_id = estabelecimento_id
    responsabilidade.obrigacao_id = obrigacao_id
    responsabilidade.user_id = user_id
    
    
    retorno = contaapi.add_responsabilidade(conta_id, estabelecimento_id, responsabilidade)
    expect(retorno.id).not_to eq (nil)
  end
  
  it "should list and delete responsabilidade on establishment" do   
    contaapi = build(:conta_service)
    conta_id = contaapi.list[0].id
    estabelecimento_id = contaapi.estabelecimentos(conta_id)[0].id
    
    userapi = build(:user_service)  
    user_id = userapi.meu_id
    
    contaapi.responsabilidades_estabelecimento(conta_id, estabelecimento_id, user_id).each do |resp|  
      if (resp.estabelecimento_id == estabelecimento_id and resp.user_id = user_id)
        contaapi.delete_responsabilidade(conta_id, resp.estabelecimento_id, resp.user_id, resp.obrigacao_id)
        break
      end
    end
    lista_resp = contaapi.responsabilidades_estabelecimento(conta_id, estabelecimento_id, user_id)
    expect(lista_resp.empty?).to eq (true)
  end
  
  it "should list and update the previosly created obrigacao" do
    contaapi = build(:conta_service)
    obrigacaoservice = build(:obrigacao_service)
    conta_id = contaapi.list[0].id
    estabelecimento_id = contaapi.estabelecimentos(conta_id)[0].id
    
    obrig_ref = build(:obrigacao)
    obrig_ref = obrigacaoservice.list_by_nome(obrig_ref.nome)[0];
    
    retorno = nil
    contaapi.list_obrigacoes(conta_id, estabelecimento_id).each do |obrig|
      if obrig.obrigacao_id == obrig_ref.id
        retorno = contaapi.update_obrigacao(conta_id, estabelecimento_id, obrig.obrigacao_id, 20)
        break
      end
    end
    expect(retorno.dia_entrega).to eq (20)
  end
  
  it "should list and delete the previosly created establishment" do
    contaapi = build(:conta_service)
    obrigacaoservice = build(:obrigacao_service)
    conta_id = contaapi.list[0].id
    estabelecimento_id = contaapi.estabelecimentos(conta_id)[0].id
    
    obrig_ref = build(:obrigacao)
    obrig_ref = obrigacaoservice.list_by_nome(obrig_ref.nome)[0];
    
    retorno = false
    contaapi.list_obrigacoes(conta_id, estabelecimento_id).each do |obrig|
      if obrig.obrigacao_id == obrig_ref.id
        contaapi.delete_obrigacao(conta_id, estabelecimento_id, obrig_ref.id)
        retorno = true
        break
      end
    end
    expect(retorno).to eq (true)
  end
  
  it "shoud delete the previosly created obrigacao" do
    obrigacaoapi = build(:obrigacao_service)
    list_obrigacaos = obrigacaoapi.list_by_nome(build(:obrigacao).nome)
    obrigacaoapi.delete(list_obrigacaos[0])
    list_obrigacaos = obrigacaoapi.list_by_nome(build(:obrigacao).nome)
    expect(list_obrigacaos.empty?).to eq (true)
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
  
end