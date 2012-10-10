require 'economic/entity'

module Economic

  # Represents a template_collection. - invoice_layout
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_ITemplateCollection.html
  #
  # Examples
  #
  #   # Find template_collection
  #   template_collection = economic.template_collection.find(5)

  class TemplateCollection < Entity
    has_properties :name

    def handle
      Handle.new({:name => @name})
    end

  end
end