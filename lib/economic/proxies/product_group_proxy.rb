require 'economic/proxies/entity_proxy'

module Economic
  class ProductGroupProxy < EntityProxy

    def find(handle)
      handle = if handle.respond_to?(:to_i)
        Entity::Handle.new(:number => handle.to_i)
      else
        Entity::Handle.new(handle)
      end
      super(handle)
    end
  
  end
end