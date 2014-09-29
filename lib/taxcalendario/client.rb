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
      
      # Retorna estabelecimento por id
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
      
    end
  end
end
