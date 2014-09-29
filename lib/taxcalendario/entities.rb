module Taxcalendario
  module Client
    module Entities
      
      # Base class for all entities
      class BaseEntity
      
        # Fill entity from hash
        def from_hash(hash)
          hash.each do |k,v|
            self.instance_variable_set("@#{k}", v)  ## create and initialize an instance variable for this key/value pair
            self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})  ## create the getter that returns the instance variable
            self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})  ## create the setter that sets the instance variable
          end
        end
        
        # Fill hash with myself fields
        def to_hash
          hash = {}
          self.instance_variables.each do |var| 
            hash[var.to_s.delete("@")] = self.instance_variable_get(var)  
          end
          hash
        end
        
      end
    
      # User entity
      class User < BaseEntity
        attr_accessor :id
        attr_accessor :email
        attr_accessor :conta_id
        attr_accessor :created_at
        attr_accessor :updated_at
        attr_accessor :name
        attr_accessor :password
        attr_accessor :role
        attr_accessor :invitation_token
        attr_accessor :invitation_created
        attr_accessor :invitation_sent_at
        attr_accessor :invitation_accepted_at
        attr_accessor :invitation_limit
        attr_accessor :invited_by_id
        attr_accessor :invited_by_type
        attr_accessor :invitations_count
      end
      
      # Account entity
      class Conta <  BaseEntity
        attr_accessor :id
        attr_accessor :nome
        attr_accessor :created_at
        attr_accessor :updated_at
        attr_accessor :ativa
        attr_accessor :demonstracao
      end
      
      # Obligation entity
      class Obrigacao < BaseEntity
        attr_accessor :id
        attr_accessor :nome
        attr_accessor :created_at
        attr_accessor :updated_at
        attr_accessor :responsavel_id
        attr_accessor :ativa
        attr_accessor :demonstracao
      end
      
      # Obligation entity
      class ErrorMessage < BaseEntity
        attr_accessor :error
      end
    end
  end
end