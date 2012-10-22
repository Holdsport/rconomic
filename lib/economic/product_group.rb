require 'economic/entity'

module Economic

  # Represents a product group.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_IProductGroup.html
  #
  # Examples
  #
  #   # Find product_group
  #   product_group = economic.product_groups.find(5)
  #
  #   # Creating a product_group
  #   product_group = economic.product_groups.build
  #   product_group.number = '5'
  #   product_group.name = 'Domestic'
  #   product_group.account_for_vat_liable_debtor_invoices_current_handle = { :number => 1012 }
  #   product_group.account_for_vat_exempt_debtor_invoices_current_handle = { :number => 1030 } # optional
  #   product_group.save

  class ProductGroup < Entity
    has_properties  :number,
                    :name,
                    :account_for_vat_exempt_debtor_invoices_current_handle,
                    :account_for_vat_liable_debtor_invoices_current_handle,
                    :accrual_handle

    def handle
      Handle.new({:number => @number})
    end

    def build_soap_data
      data = ActiveSupport::OrderedHash.new

      data['Handle'] = handle.to_hash
      data['Number'] = number
      data['Name'] = name
      data['AccountForVatLiableDebtorInvoicesCurrentHandle'] = { 'Number' => account_for_vat_liable_debtor_invoices_current_handle[:number] }
      data['AccountForVatExemptDebtorInvoicesCurrentHandle'] = { 'Number' => account_for_vat_exempt_debtor_invoices_current_handle[:number] } unless account_for_vat_exempt_debtor_invoices_current_handle.blank?
      data['AccrualHandle'] = { 'Number' => accrual_handle[:number] } unless accrual_handle.blank?
      
      return data
    end

  end
end