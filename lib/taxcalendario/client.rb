require "taxcalendario/client/version"
require "taxcalendario/entities"
require "httpclient"
require "json"
require "taxcalendario/baseclient"

module Taxcalendario
  module Client
    # User service API Client
    class UserService < BasicClient
      
      # Constructor
      def initialize
        self.service_base_path = "/users"
        super
      end
      
      # New entity for this class
      def new_entity
        Taxcalendario::Client::Entities::User.new
      end
      
      # List and filter by name
      def list_by_name(name)
        params = Hash.new
        params[:name] = name
        self.list(params)
      end
      
      # List and filter by e-maill
      def list_by_email(email)
        params = Hash.new
        params[:email] = email
        self.list(params)
      end
      
      # Return own id
      def meu_id
        id = Integer(self.get_and_give_me_a_json("meuid"))
        id
      end
      
      # Return all accounts
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
    
    # Obrigacao service API client
    class ObrigacaoService < BasicClient
      def initialize
        self.service_base_path = "/obrigacao"
        super
      end
    end
    
    # Conta service API client
    class ContaService < BasicClient
      def initialize
        self.service_base_path = "/conta"
        super
      end
    end
  end
end
