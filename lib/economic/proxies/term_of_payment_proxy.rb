require 'economic/proxies/entity_proxy'

module Economic
  class TermOfPaymentProxy < EntityProxy

    # # Fetches TermOfPayment from API
    def find(handle)
      handle = if handle.respond_to?(:to_i)
        Entity::Handle.new(:id => handle.to_i)
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
        Array( find(handles.first) )
      elsif handles.size > 1
        @array = []
        for handle in handles
          @array << find(handle)
        end
        @array
      end
      
    end
  
  end
end