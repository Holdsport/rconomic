require 'economic/proxies/entity_proxy'

module Economic
  class AccountProxy < EntityProxy
    def find(handle)
      handle = if handle.respond_to?(:to_i)
        Entity::Handle.new(:number => handle.to_i)
      else
        Entity::Handle.new(handle)
      end
      super(handle)
    end

    def find_by_name(name)
      response = session.request entity_class.soap_action('FindByName') do
        soap.body = {
          'name' => name
        }
      end
      
      handles = response.values.flatten.collect { |handle| Entity::Handle.new(handle) }
      if handles.size == 1
        find(handles.first)
      else handles.size > 1

        entity_data = session.request(entity_class.soap_action(:get_data_array)) do
          soap.body = {'entityHandles' => {"AccountHandle" => handles.collect(&:to_hash)}}
        end

        entity_data[:account_data].each do |data|
          entity = build(data)
          entity.persisted = true
        end

        entity_data[:account_data]
      end
      
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

    def all
      response = session.request(entity_class.soap_action(:get_all))
      handles = response.values.flatten.collect { |handle| Entity::Handle.new(handle) }

      if handles.size == 1
        # Fetch data for single entity
        find(handles.first)
      elsif handles.size > 1
        entity_class_name = entity_class.name.split('::').last

        # Fetch all data for all the entities
        entity_data = session.request(entity_class.soap_action(:get_data_array)) do
          soap.body = {'entityHandles' => {"#{entity_class_name}Handle" => handles.collect(&:to_hash)}}
        end

        # Build Entity objects and add them to the proxy
        entity_data["#{entity_class.key}_data".intern].each do |data|
          entity = build(data)
          entity.persisted = true
        end
      end
    end

  end
end
