require 'economic/entity'

module Economic

  # Represents a debtor group.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_IDebtorGroup.html
  #
  # Examples
  #
  #   # Find debtor_groups
  #   debtor_groups = economic.debtor_groups.find(5)
  #
  #   # Creating a debtor_groups
  #   debtor_groups = economic.debtor_groups.build
  #   debtor_groups.account = ???
  #   debtor_groups.number = 0
  #   debtor_groups.name = 'Domestic'
  #   debtor_groups.save

  class DebtorGroup < Entity
    has_properties :account, :number, :name

    def handle
      Handle.new({:number => @number})
    end

    protected

    def build_soap_data
      data = ActiveSupport::OrderedHash.new

      data['Handle'] = handle.to_hash
      data['Account'] = account
      data['Name'] = name
      data['Number'] = number
      
      return data
    end
  end
end