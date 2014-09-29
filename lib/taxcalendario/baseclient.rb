module Taxcalendario
  module Client
    class BasicClient
      
      attr_accessor :access_token
      attr_accessor :base_url
      attr_accessor :http_client
      attr_accessor :service_base_path
      
      # Constructor
      def initialize
        self.base_url = "http://localhost:3000/api/v1"
        self.access_token = nil
        self.http_client = HTTPClient.new
      end
      
      # New entity. Override this in children classes.
      def new_entity
        nil
      end
      
      # Get entity by id
      def get(id)
        json = self.http_client.get_content "#{self.base_url}#{self.service_base_path}/#{id}.json", :api_key => self.access_token
        ne = new_entity
        ne.from_hash(JSON.parse(trata_erro(json)))
        ne
      end
      
      # Get entity by id
      def get(id)
        json = self.http_client.get_content "#{self.base_url}#{self.service_base_path}/#{id}.json", :api_key => self.access_token
        ne = new_entity
        ne.from_hash(JSON.parse(trata_erro(json)))
        ne
      end
      
      # Add a register
      def add(entity)
        params = entity.to_hash
        httpresp = self.http_client.post "#{self.base_url}#{self.service_base_path}.json?api_key=#{self.access_token}", params
        json = httpresp.content
        trata_erro(json)
        ne = new_entity
        ne.from_hash(JSON.parse(json))
        ne
      end
      
      def trata_erro(json)
        if json.include?("\"error\":")
          em = Taxcalendario::Client::Entities::ErrorMessage.new
          em.from_hash(JSON.parse(json))
          raise em.error
        else
          json
        end
      end
      
      # Add a register
      def update(entity)
        params = entity.to_hash
        httpresp = self.http_client.put "#{self.base_url}#{self.service_base_path}.json?api_key=#{self.access_token}", params
        json = httpresp.content
        trata_erro(json)
        ne = new_entity
        ne.from_hash(JSON.parse(json))
        ne
      end
      
      # Delete a register
      def delete(entity)
        httpresp = self.http_client.delete "#{self.base_url}#{self.service_base_path}.json?id=#{entity.id}&api_key=#{self.access_token}"
        json = httpresp.content
        trata_erro(json)
        true
      end
      
      # Get path and return a json
      def get_and_give_me_a_json(additional_path, params = nil)
        if self.service_base_path != nil
          if params == nil
            params = Hash.new
          end
          params[:api_key] = self.access_token
          json = self.http_client.get_content "#{self.base_url}#{self.service_base_path}/#{additional_path}.json", params
          trata_erro(json)
        end
      end
      
      # Get path and return a json
      def delete_and_give_me_a_json(additional_path, params = nil)
        if self.service_base_path != nil
          if params == nil
            params = Hash.new
          end
          params[:api_key] = self.access_token
          message = self.http_client.delete "#{self.base_url}#{self.service_base_path}/#{additional_path}.json", params
          trata_erro(message.content)
        end
      end
      
      # Post in path and return a json
      def post_and_give_me_a_json(additional_path, entity)
        if self.service_base_path != nil
          message = self.http_client.post "#{self.base_url}#{self.service_base_path}/#{additional_path}.json?api_key=#{self.access_token}", entity.to_hash
          trata_erro(message.content)
        end
      end
      
      # Put in path and return a json
      def put_and_give_me_a_json(additional_path, entity)
        if self.service_base_path != nil
          message = self.http_client.put "#{self.base_url}#{self.service_base_path}/#{additional_path}.json?api_key=#{self.access_token}", entity.to_hash
          trata_erro(message.content)
        end
      end
      
      # List
      def list(params = nil)
        if self.service_base_path != nil
          if params == nil
            params = Hash.new
          end
          params[:api_key] = self.access_token
          json = self.http_client.get_content "#{self.base_url}#{self.service_base_path}/list.json", params
          trata_erro(json)
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
  end
end