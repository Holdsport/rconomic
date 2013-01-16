require 'economic/entity'

module Economic

  # Represents a creditor entry in E-conomic.
  #
  # API documentation: http://e-conomic.github.com/eco-api-sdk-ref-docs/Documentation/T_Economic_Api_IDepartment.html

  class Department < Entity
    has_properties :name, :number

    def handle
      Handle.new({:number => @number})
    end
    
  end

end
