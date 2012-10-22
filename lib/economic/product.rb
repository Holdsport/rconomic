require 'economic/entity'

module Economic

  # Represents a product.
  #
  # API documentation: http://e-conomic.github.com/eco-api-sdk-ref-docs/Documentation/
  #
  # Examples
  #
  #   # Find product
  #   product = economic.products.find(42)
  #
  #   # Creating a product
  #   product = economic.products.build
  #   product.number = '309'
  #   product.name = 'MacBook Air'
  #   product.product_group_handle = { :number => 2 }
  #   product.description = 'A laptop from apple'
  #   product.sales_price = 100
  #   product.cost_price = 30
  #   product.recommended_price = 90
  #   product.is_accessible = true
  #   product.bar_code = 'What ever'
  #   product.save

  class Product < Entity
    has_properties :available,
      :bar_code,
      :cost_price,
      :department_handle,
      :description,
      :distribution_key_handle,
      :in_stock,
      :is_accessible,
      :name,
      :number,
      :on_order,
      :ordered,
      :product_group_handle,
      :recommended_price,
      :sales_price,
      :unit_handle,
      :volume

    def handle
      Handle.new({:number => @number})
    end

    protected

    def initialize_defaults
      self.bar_code = ""
      self.sales_price = 0
      self.cost_price = 0
      self.recommended_price = 0
      self.description = ""
      self.is_accessible = true
      self.volume = 0
      self.unit_handle = nil
      self.department_handle = nil
      self.distribution_key_handle = nil
    end

    def build_soap_data
      data = ActiveSupport::OrderedHash.new

      data['Handle'] = handle.to_hash
      data['Number'] = number
      data['ProductGroupHandle'] = { 'Number' => product_group_handle[:number] }
      data['Name'] = name
      data['Description'] = description
      data['BarCode'] = bar_code
      data['SalesPrice'] = sales_price
      data['CostPrice'] = cost_price
      data['RecommendedPrice'] = recommended_price
      data['UnitHandle'] = { 'Number' => unit_handle[:number] } unless unit_handle.blank?
      data['IsAccessible'] = is_accessible
      data['Volume'] = volume
      data['DepartmentHandle'] = { 'Number' => department_handle[:number] } unless unit_handle.blank?
      data['DistributionKeyHandle'] = { 'Number' => distribution_key_handle[:number] } unless unit_handle.blank?
      data['InStock'] = in_stock
      data['OnOrder'] = on_order
      data['Ordered'] = ordered
      data['Available'] = available
      
      return data
    end

  end
end