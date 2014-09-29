module Taxcalendario
  module Client
    module Entities
      
      # Entidade base. Nao deve ser usada diretamente.
      class BaseEntity
      
        # Preenche entidade a partir de um hash
        def from_hash(hash)
          hash.each do |k,v|
            self.instance_variable_set("@#{k}", v)  ## create and initialize an instance variable for this key/value pair
            self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})  ## create the getter that returns the instance variable
            self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})  ## create the setter that sets the instance variable
          end
        end
        
        # Converte entidade para hash
        def to_hash
          hash = {}
          self.instance_variables.each do |var| 
            hash[var.to_s.delete("@")] = self.instance_variable_get(var)  
          end
          hash
        end
        
      end
    
      # Usuario
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
      
      # Conta
      class Conta <  BaseEntity
        attr_accessor :id
        attr_accessor :nome
        attr_accessor :created_at
        attr_accessor :updated_at
        attr_accessor :ativa
        attr_accessor :demonstracao
      end
      
      # Obrigacao
      class Obrigacao < BaseEntity
        attr_accessor :id
        attr_accessor :nome
        attr_accessor :created_at
        attr_accessor :updated_at
        attr_accessor :responsavel_id
        attr_accessor :ativa
        attr_accessor :demonstracao
      end
      
      # Conta User
      class ContaUser < BaseEntity
        attr_accessor :id
        attr_accessor :conta_id
        attr_accessor :user_id
        attr_accessor :role
      end
      
      # Responsabilidade
      class Responsabilidade < BaseEntity
        attr_accessor :id
        attr_accessor :estabelecimento_id
        attr_accessor :obrigacao_id
        attr_accessor :user_id
        attr_accessor :dt_inicio
        attr_accessor :dt_fim
        attr_accessor :responsabilidade
        attr_accessor :created_at
        attr_accessor :updated_at
      end
      
      # Estabelecimento
      class Estabelecimento < BaseEntity
        attr_accessor :id
        attr_accessor :nome
        attr_accessor :cnpj
        attr_accessor :ie
        attr_accessor :cnaes
        attr_accessor :uf
        attr_accessor :municipio
        attr_accessor :dt_inicio
        attr_accessor :dt_fim
        attr_accessor :created_at
        attr_accessor :updated_at
        attr_accessor :conta_id
        attr_accessor :ie_sede
        attr_accessor :apuracao_lucro
        attr_accessor :simples_nacional
        attr_accessor :mei
      end
      
      # Obligation entity
      class ErrorMessage < BaseEntity
        attr_accessor :error
      end
    end
  end
end