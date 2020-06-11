require "riot-dm-transactional/version"

class Transactional < Riot::ContextMiddleware

  def call(context)

    middleware.call(context)
    
    if context.option(:transactional) 
      context.setup(true) {
        ::DataMapper.repository.scope do |repository|
          transaction = DataMapper::Transaction.new(repository)
          transaction.begin
          repository.adapter.push_transaction(transaction)
        end
      }
      
      context.teardown {
        while ::DataMapper.repository.adapter.current_transaction
          ::DataMapper.repository.adapter.pop_transaction.rollback
        end      
      }
    end
  end
  
  register
end