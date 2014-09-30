require "taxcalendario/client/version"
require "taxcalendario/entities"
require "httpclient"
require "json"
require "taxcalendario/baseclient"

module Taxcalendario
  module Client
    # API Client do servico de usuario
    class UserService < BasicClient
      
      # Construtor
      def initialize
        self.service_base_path = "/users"
        super
      end
      
      # Nova instancia de entidade de usuario
      def new_entity
        Taxcalendario::Client::Entities::User.new
      end
      
      # Lista usuarios filtrando por nome
      def list_by_name(name)
        params = Hash.new
        params[:name] = name
        self.list(params)
      end
      
      # Lista usuarios filtrando por e-mail
      def list_by_email(email)
        params = Hash.new
        params[:email] = email
        self.list(params)
      end
      
      # Retorna id do usuario do token
      def meu_id
        id = Integer(self.get_and_give_me_a_json("meuid"))
        id
      end
      
      # Retorna todas as contas
      def contas
        list_contas = JSON.parse(get_and_give_me_a_json("/contas"))
        rtn = []
        list_contas.each do |c_map|
          conta = Taxcalendario::Client::Entities::Conta.new
          conta.from_hash(c_map)
          rtn << conta
        end
        rtn
      end
      
    end
    
    # API Client da Obrigacao
    class ObrigacaoService < BasicClient
      def initialize
        self.service_base_path = "/obrigacao"
        super
      end   
      
      # Nova instancia da entidade padrao deste servico
      def new_entity
        Taxcalendario::Client::Entities::Obrigacao.new
      end    
      
      # Lista obricacoes filtrando por nome
      def list_by_nome(nome)
        params = Hash.new
        params[:nome] = nome
        self.list(params)
      end  
      
    end
    
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
      
      # Retorna os usuarios
      def users_list(conta_id)
        list_contas = JSON.parse(get_and_give_me_a_json("/users/#{conta_id}"))
        rtn = []
        list_contas.each do |u_map|
          user = Taxcalendario::Client::Entities::User.new
          user.from_hash(u_map)
          rtn << user
        end
        rtn
      end
      
      # Retorna os usuarios
      def add_user(conta_id, user, role)
        cu = ContaUser.new
        cu.conta_id = conta_id
        cu.user_id = user.id
        cu.role = role
        
        json = post_and_give_me_a_json("/users/#{conta_id}", cu)
        response = ContaUser.new
        response.from_hash(JSON.parse(json))
        response.id > 0
      end
      
      # Retorna usuarios
      def responsabilidades(conta_id, user_id)
        list = JSON.parse(get_and_give_me_a_json("/users/#{conta_id}/#{user_id}/responsabilidades"))
        rtn = []
        list.each do |map|
          obj = Taxcalendario::Client::Entities::Responsabilidade.new
          obj.from_hash(map)
          rtn << obj
        end
        rtn
      end
      
      # Adiciona uma responsabilidade
      def add_responsabilidade(conta_id, estabelecimento_id, responsabilidade)
        
      end
      
      # Remove uma responsabilidade
      def delete_responsabilidade(conta_id, estabelecimento_id, user_id, obrigacao_id)
        
      end
      
      # Responsabilidades registradas em um estabelecimento
      def responsabilidades_estabelecimento(conta_id, estabelecimento_id, user_id)
        
      end
      
      # Lista todas as obrigacoes de um estabelecimento
      def list_obrigacoes(conta_id, estabelecimento_id)
        list_contas = JSON.parse(get_and_give_me_a_json("/estabelecimentos/obrigacoes/#{conta_id}/#{estabelecimento_id}/list"))
        rtn = []
        list_contas.each do |u_map|
          obrig = Taxcalendario::Client::Entities::Obrigacao.new
          obrig.from_hash(u_map)
          rtn << obrig
        end
        rtn
      end
      
      # Adiciona uma obrigacao a um estabelecimento
      def add_obrigacao(conta_id, estabelecimento_id, obrigacao_id, dia_entrega)
        obest = Taxcalendario::Client::Entities::ObrigacaoEstabelecimento.new
        obest.dia_entrega = dia_entrega
        obest.obrigacao_id = obrigacao_id
        map = JSON.parse(post_and_give_me_a_json("/estabelecimentos/obrigacoes/#{conta_id}/#{estabelecimento_id}",obest))     
        obj = Taxcalendario::Client::Entities::ObrigacaoEstabelecimento.new
        obj.from_hash(map)
        obj
      end
      
      # Atualiza uma obrigacao
      def update_obrigacao(conta_id, estabelecimento_id, obrigacao_id, dia_entrega)
        obest = Taxcalendario::Client::Entities::ObrigacaoEstabelecimento.new
        obest.obrigacao_id = obrigacao_id
        obest.dia_entrega = dia_entrega
        map = JSON.parse(put_and_give_me_a_json("/estabelecimentos/obrigacoes/#{conta_id}/#{estabelecimento_id}",obest))     
        obj = Taxcalendario::Client::Entities::ObrigacaoEstabelecimento.new
        obj.from_hash(map)
        obj
      end
      
      # Remove obrigacao
      def delete_obrigacao(conta_id, estabelecimento_id, obrigacao_id)
         delete_and_give_me_a_json("estabelecimentos/obrigacoes/#{conta_id}/#{estabelecimento_id}/#{obrigacao_id}")
      end
      
      # Retorna estabelecimentos
      def estabelecimentos(conta_id)
        list = JSON.parse(get_and_give_me_a_json("/estabelecimentos/#{conta_id}"))
        rtn = []
        list.each do |map|
          obj = Taxcalendario::Client::Entities::Estabelecimento.new
          obj.from_hash(map)
          rtn << obj
        end
        rtn
      end
      
      # Retorna estabelecimento por id
      def estabelecimento(conta_id, estabelecimento_id)
        map = JSON.parse(get_and_give_me_a_json("/#{conta_id}/estabelecimentos/#{estabelecimento_id}"))
        obj = Taxcalendario::Client::Entities::Estabelecimento.new
        obj.from_hash(map)
        obj
      end
      
      # Atualiza um estabelecimento
      def update_estabelecimento(estabelecimento)
        map = JSON.parse(put_and_give_me_a_json("/estabelecimentos/#{estabelecimento.conta_id}/#{estabelecimento.id}",estabelecimento))
        obj = Taxcalendario::Client::Entities::Estabelecimento.new
        obj.from_hash(map)
        obj
      end
      
      # Deleta estabelecimento
      def delete_estabelecimento(estabelecimento)
        delete_and_give_me_a_json("/estabelecimentos/#{estabelecimento.conta_id}/#{estabelecimento.id}")
      end
      
      # Retorna estabelecimentos
      def add_estabelecimento(estabelecimento)
        map = JSON.parse(post_and_give_me_a_json("/estabelecimentos/#{estabelecimento.conta_id}",estabelecimento))
        obj = Taxcalendario::Client::Entities::Estabelecimento.new
        obj.from_hash(map)
        obj
      end
      
      # Lista entregas
      def list_entregas(conta_id, estabelecimento_id, obrigacao_id)
        list = JSON.parse(get_and_give_me_a_json("/estabelecimentos/entregas/#{conta_id}/#{estabelecimento_id}/#{obrigacao_id}"))
        rtn = []
        list.each do |map|
          obj = Taxcalendario::Client::Entities::Entrega.new
          obj.from_hash(map)
          rtn << obj
        end
        rtn
      end
      
      # Pega entrega por id
      def get_entrega(conta_id, entrega_id)
        map = JSON.parse(get_and_give_me_a_json("/estabelecimentos/entregas/#{conta_id}/#{entrega_id}"))
        obj = Taxcalendario::Client::Entities::Entrega.new
        obj.from_hash(map)
        obj
      end
      
      # Adiciona entrega
      def add_entrega(conta_id, entrega)
        map = JSON.parse(post_and_give_me_a_json("/estabelecimentos/entregas/#{conta_id}/#{entrega.estabelecimento_id}", entrega))
        obj = Taxcalendario::Client::Entities::Entrega.new
        obj.from_hash(map)
        obj
      end
      
      # Atualiza entrega
      def update_entrega(conta_id, entrega)
        map = JSON.parse(put_and_give_me_a_json("/estabelecimentos/entregas/#{conta_id}/#{entrega.estabelecimento_id}", entrega))
        obj = Taxcalendario::Client::Entities::Entrega.new
        obj.from_hash(map)
        obj
      end
      
      # Deleta entrega
      def delete_entrega(conta_id, entrega_id)
        delete_and_give_me_a_json("/estabelecimentos/entregas/#{conta_id}/#{entrega_id}")
      end
      
      # Adiciona um arquivo a uma entrega
      def add_arquivo_entrega(entrega_id, arquivo)
      
      end
      
    end
  end
end
