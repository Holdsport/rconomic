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

  end
end