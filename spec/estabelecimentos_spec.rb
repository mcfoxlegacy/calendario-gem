require 'factory_girl'
require 'taxcalendario/client'
require 'support/factory_girl.rb'

# Include FactoryGirl module
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

describe "Establishment service API Client" do
  
  it "should add an establishment" do
    estapi = build(:estabelecimento_service)
    est = build(:estabelecimento)
    est = estapi.adiciona(est)
    expect(est.id).not_to eq (nil)
  end
  
  it "should return my establishments" do
    estapi = build(:estabelecimento_service)
    esta = build(:estabelecimento)
    lc = estapi.lista
    ok = false
    lc.each do |est|
      if(est.nome == esta.nome)
        ok = true
        break
      end
    end
    expect(ok).not_to eq (false)
  end
  
  it "should update establishment" do
    estapi = build(:estabelecimento_service)
    esta = build(:estabelecimento)
    lc = estapi.lista
    saved = nil
    lc.each do |est|
      if(est.nome == esta.nome)
        saved = est
        break
      end
    end
    expect(saved).not_to eq (nil)
    saved.mei = true
    new_est = estapi.atualiza(saved)
    expect(new_est.mei).not_to eq (false)
  end
  
  it "should get establishment" do
    estapi = build(:estabelecimento_service)
    esta = build(:estabelecimento)
    lc = estapi.lista
    saved = nil
    lc.each do |est|
      if(est.nome == esta.nome)
        saved = est
        break
      end
    end
    new_est = estapi.pega(saved.id)
    expect(new_est.id).not_to eq (nil)
  end
  
  it "should delete establishment" do
    estapi = build(:estabelecimento_service)
    esta = build(:estabelecimento)
    lc = estapi.lista
    saved = nil
    lc.each do |est|
      if(est.nome == esta.nome)
        saved = est
        break
      end
    end
    new_est = estapi.deleta(saved.id)
    expect(saved.id).not_to eq (nil)
  end
  
  it "should get obligations from establishment" do
    estapi = build(:estabelecimento_service)
    
    lc = estapi.lista
    ok = false
    lc.each do |est|
      lst = estapi.obrigacoes(est.id)
      lst.each do |obj|
        if(obj.nome != nil)
          ok = true
          break
        end
      end
      if(ok)
        break
      end
    end
    
    expect(ok).not_to eq (false)
  end
  
  it "should add suggested obligations" do
    estapi = build(:estabelecimento_service)
    
    lc = estapi.lista
    ok = false
    lc.each do |est|
      ok = estapi.obrigacoes_sugeridas(est.id)
      if(ok)
        break
      end
    end
    
    expect(ok).not_to eq (false)
  end
  
  it "should add and remove an obligation" do
    estapi = build(:estabelecimento_service)
    esta = build(:estabelecimento)
    saved = estapi.adiciona(esta)
    
    obrigacao = estapi.adiciona_obrigacao(saved.id,"DCTF")
    
    expect(obrigacao.nome).to eq ("DCTF")
    
    ok = estapi.remove_obrigacao(saved.id,"DCTF")
    
    expect(ok).not_to eq (false)
    
    estapi.deleta(saved.id)
  end
  
  it "should return my deliveries" do
    estapi = build(:estabelecimento_service)
    
    lc = estapi.lista
    ok = false
    dt_inicio = Time.now
    dt_fim = Time.now + (31 * 24 * 60 * 60)
    lc.each do |est|
      lst = estapi.entregas(est.id, dt_inicio, dt_fim)
      ok = lst.count > 0
      if(ok)
        break
      end
    end
    
    expect(ok).not_to eq (false)
  end
  
  it "should return my deliveries by obligations" do
    estapi = build(:estabelecimento_service)
    
    lc = estapi.lista
    ok = false
    dt_inicio = Time.now
    dt_fim = Time.now + (31 * 24 * 60 * 60)
    lc.each do |est|
      lst = estapi.entregas_por_obrigacao(est.id, "DCTF", dt_inicio, dt_fim)
      ok = lst.count > 0
      if(ok)
        break
      end
    end
    
    expect(ok).not_to eq (false)
  end
  
  it "should mark delivery as generated" do
    estapi = build(:estabelecimento_service)
    
    lc = estapi.lista
    ok = false
    dt_inicio = Time.now
    dt_fim = Time.now + (31 * 24 * 60 * 60)
    lc.each do |est|
      lst = estapi.entregas_por_obrigacao(est.id, "DCTF", dt_inicio, dt_fim)
      nome = lst[0].obrigacao.nome
      geradas = estapi.marca_entregas_geradas(est.id, nome, Time.parse(lst[0].dt_prevista))
      geradas.each do |gerada|
        if gerada.obrigacao_gerada 
          ok = true
          break
        end
      end
      
      if(ok)
        break
      end
    end
    
    expect(ok).not_to eq (false)
  end
  
end