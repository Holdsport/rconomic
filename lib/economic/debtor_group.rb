require 'economic/entity'

module Economic

  # Represents a debtor group.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_IDebtorGroup.html
  #
  # Examples
  #
  #   # Find a debtor_group
  #   debtor_groups = economic.debtor_groups.find(5)
  #
  #   # Creating a debtor_group
  #   debtor_groups = economic.debtor_groups.build
  #   debtor_groups.account_handle = { :number => 5800}
  #   debtor_groups.number = 4
  #   debtor_groups.name = 'Domestic'
  #   debtor_groups.save

  class DebtorGroup < Entity
    has_properties :number, :name, :account_handle

    def handle
      Handle.new({:number => @number})
    end

    protected

    def build_soap_data
      data = ActiveSupport::OrderedHash.new

      data['Handle'] = handle.to_hash
      data['Name'] = name
      data['Number'] = number
      data['AccountHandle'] = { 'Number' => account_handle[:number] } unless account_handle.blank?
      
      return data
    end
  end
end