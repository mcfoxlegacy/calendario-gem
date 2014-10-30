require "taxcalendario/client/version"
require "taxcalendario/entities"
require "httpclient"
require "json"
require "taxcalendario/baseclient"

module Taxcalendario
  module Client
    # API Client do servico de usuario
      
    # Conta service API client
    class ContaService < BasicClient
      
      # Construtor
      def initialize
        self.service_base_path = "/conta"
        super
      end
      
      # Nova instancia da entidade padrao deste servico
      def new_entity
        Taxcalendario::Client::Entities::Conta.new
      end
      
      def minha
        cmap = JSON.parse(get_and_give_me_a_json("/minha"))
        conta = Taxcalendario::Client::Entities::Conta.new
        conta.from_hash(cmap)
        conta
      end
      
      def entregas(dt_inicio, dt_fim)
        if dt_inicio != nil && dt_inicio.class.name == "Time" && dt_fim != nil && dt_fim.class.name == "Time"
          params = {:dt_inicio => dt_inicio.strftime("%Y-%m-%d"), :dt_fim => dt_fim.strftime("%Y-%m-%d")}
          entregas = JSON.parse(get_and_give_me_a_json("/entregas",params))
          rtn = []
          entregas.each do |entrega|
            ent = Taxcalendario::Client::Entities::Entrega.new
            ent.from_hash(entrega)
            rtn << ent
          end
          rtn
        else
          false
        end
      end
      
      def arquivo(file_path)
        rtn = false
        if post_file_and_give_me_a_json("/arquivo",file_path) != nil
          rtn = true
        end
        rtn
      end
      
    end
    
    
    # Conta service API client
    class EstabelecimentoService < BasicClient
      
      # Construtor
      def initialize
        self.service_base_path = "/estabelecimentos"
        super
      end
      
      # Nova instancia da entidade padrao deste servico
      def new_entity
        Taxcalendario::Client::Entities::Estabelecimento.new
      end
      
      def lista
        estabs = JSON.parse(get_and_give_me_a_json(nil))
        rtn = []
        estabs.each do |estab|
          est = Taxcalendario::Client::Entities::Estabelecimento.new
          est.from_hash(estab)
          rtn << est
        end
        rtn
      end
      
      def adiciona(estabelecimento)
        map = JSON.parse(post_and_give_me_a_json(nil, estabelecimento))
        est = Taxcalendario::Client::Entities::Estabelecimento.new
        est.from_hash(map)
        est
      end
      
      def atualiza(estabelecimento)
        map = JSON.parse(put_and_give_me_a_json("/#{estabelecimento.id}", estabelecimento))
        est = Taxcalendario::Client::Entities::Estabelecimento.new
        est.from_hash(map)
        est
      end
      
      def pega(id)
        map = JSON.parse(get_and_give_me_a_json("/#{id}"))
        est = Taxcalendario::Client::Entities::Estabelecimento.new
        est.from_hash(map)
        est
      end
      
      def deleta(id)
        map = JSON.parse(delete_and_give_me_a_json("/#{id}"))
        rtn = map["message"].include?("sucesso")
        rtn
      end
      
      def obrigacoes(id)
        lst = JSON.parse(get_and_give_me_a_json("/#{id}/obrigacoes"))
        rtn = []
        lst.each do |estab|
          obj = Taxcalendario::Client::Entities::Obrigacao.new
          obj.from_hash(estab)
          rtn << obj
        end
        rtn
      end
      
      def obrigacoes_sugeridas(id)
        map = JSON.parse(post_and_give_me_a_json("/#{id}/obrigacoes_sugeridas"))
        rtn = map["message"].include?("sucesso")
        rtn
      end
      
      def adiciona_obrigacao(id, obrig_nome)
        map = JSON.parse(post_and_give_me_a_json("/#{id}/obrigacoes/#{obrig_nome}"))
        obj = Taxcalendario::Client::Entities::Obrigacao.new
        obj.from_hash(map)
        obj
      end
      
      def remove_obrigacao(id, obrig_nome)
        map = JSON.parse(delete_and_give_me_a_json("/#{id}/obrigacoes/#{obrig_nome}"))
        rtn = map["message"].include?("sucesso")
        rtn
      end
      
      def entregas(id, dt_inicio, dt_fim)
        if id != nil && dt_inicio != nil && dt_inicio.class.name == "Time" && dt_fim != nil && dt_fim.class.name == "Time"
          params = {:dt_inicio => dt_inicio.strftime("%Y-%m-%d"), :dt_fim => dt_fim.strftime("%Y-%m-%d")}
          entregas = JSON.parse(get_and_give_me_a_json("/#{id}/entregas",params))
          rtn = []
          entregas.each do |entrega|
            ent = Taxcalendario::Client::Entities::Entrega.new
            ent.from_hash(entrega)
            rtn << ent
          end
          rtn
        else
          false
        end
      end
      
      def entregas_por_obrigacao(id, nome, dt_inicio, dt_fim)
        if id != nil && dt_inicio != nil && dt_inicio.class.name == "Time" && dt_fim != nil && dt_fim.class.name == "Time"
          params = {:dt_inicio => dt_inicio.strftime("%Y-%m-%d"), :dt_fim => dt_fim.strftime("%Y-%m-%d")}
          entregas = JSON.parse(get_and_give_me_a_json("/#{id}/obrigacoes/#{nome}/entregas",params))
          rtn = []
          entregas.each do |entrega|
            ent = Taxcalendario::Client::Entities::Entrega.new
            ent.from_hash(entrega)
            rtn << ent
          end
          rtn
        else
          false
        end
      end
      
    end
      
  end
end

