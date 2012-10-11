require 'economic/proxies/entity_proxy'

module Economic
  class TemplateCollectionProxy < EntityProxy
    def find_by_name(name)
      response = session.request entity_class.soap_action('FindByName') do
        soap.body = {
          'name' => name
        }
      end
      
      entity = build(response)
      entity.name = name
      entity.persisted = true
      entity
      
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

      entity_data[:template_collection_data]
    end

  end
end