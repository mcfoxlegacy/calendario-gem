require "taxcalendario/client/version"
require "taxcalendario/entidades"
require "httpclient"
require "json"

module Taxcalendario
  module Client
    class BasicClient
      
      # Constructor
      def initialize
        @base_url = "http://localhost:3000/api/v1"
        @access_token = nil
        @http_client = HTTPClient.new
      end
      
      # Define base URL for API access
      def set_base_url(base_url)
        @base_url = base_url
      end
      
      # Define API Token
      def set_access_token(token)
        @access_token = token
      end
      
      # New entity. Override this in children classes.
      def new_entity
        nil
      end
      
      # Get entity by id
      def get(id)
        json = @http_client.get_content "#{@base_url}#{@service_base_path}/#{id}.json"
        ne = new_entity
        ne.from_hash(JSON.parse(json))
        ne
      end
      
      # Get path and return a json
      def get_and_give_me_a_json(additional_path, params = nil)
        if @service_base_path != nil
          if params == nil
            params = Hash.new
          end
          params[:api_key] = @access_token
          json = @http_client.get_content "#{@base_url}#{@service_base_path}/#{additional_path}.json", params
          json
        end
      end
      
      # List
      def list(params = nil)
        if @service_base_path != nil
          if params == nil
            params = Hash.new
          end
          params[:api_key] = @access_token
          json = @http_client.get_content "#{@base_url}#{@service_base_path}/list.json", params
          rtn = []
          JSON.parse(json).each do |obj_hash|
            ne = new_entity
            ne.from_hash(obj_hash)
            rtn << ne
          end
          rtn
        end
      end
    end
    
    # User service API Client
    class UserService < BasicClient
      
      # Constructor
      def initialize
        @service_base_path = "/users"
        super
      end
      
      # New entity for this class
      def new_entity
        Taxcalendario::Client::Entities::User.new
      end
      
      # List and filter by name
      def list_by_name(name)
        self.list([:name => name])
      end
      
      # List and filter by e-maill
      def list_by_email(email)
        self.list([:email => email])
      end
      
      # Return own id
      def meu_id
        id = Integer(self.get_and_give_me_a_json("meuid"))
        id
      end
      
    end
    
    # Obrigacao service API client
    class ObrigacaoService < BasicClient
      def initialize
        @service_base_path = "/obrigacao"
        super
      end
    end
    
    # Conta service API client
    class ContaService < BasicClient
      def initialize
        @service_base_path = "/conta"
        super
      end
    end
  end
end
