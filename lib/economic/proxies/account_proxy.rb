require 'economic/proxies/entity_proxy'

module Economic
  class AccountProxy < EntityProxy
    def find_by_name(name)
      response = session.request entity_class.soap_action('FindByName') do
        soap.body = {
          'name' => name
        }
      end
      
      handle = response[:account_handle]
      
      entity = build(response)
      entity.name = name
      entity.number = handle[:number]
      entity.persisted = true
      entity
      
    end

    def all
      response = session.request entity_class.soap_action('GetAll')

      handles = [response[:account_handle]].flatten.reject(&:blank?)
      accounts = []
      handles.each do |handle|
        accounts << get_name(handle[:number])
      end
      
      accounts
    end

    def get_name(id)
      response = session.request entity_class.soap_action("GetName") do
        soap.body = {
          'accountHandle' => {
            'Number' => id
          }
        }
      end

      account = build
      account.number = id
      account.name = response
      account
    end

  end
end
