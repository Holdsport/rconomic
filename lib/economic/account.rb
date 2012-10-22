require 'economic/entity'

module Economic

  # Represents an account.
  #
  # API documentation: http://e-conomic.github.com/eco-api-sdk-ref-docs/Documentation/
  #
  # Examples
  #
  #   # Find account
  #   account = economic.accounts.find(1000)
  #
  #   # Creating an account
  #   account = economic.accounts.build
  #   account.number = '1050'
  #   account.name = 'Sales in EU'
  #   account.type = 'ProfitAndLoss'
  #   account.debit_credit = 'Credit'
  #   account.vat_account_handle = { :vat_code => "B25" }
  #   account.save

  #   # Account types
  #   ProfitAndLoss, Status, TotalFrom, Heading, HeadingStart, SumInterval

  class Account < Entity
    has_properties :name,
      :number,
      :balance,
      :block_direct_entries,
      :contra_account_handle,
      :debit_credit,
      :department_handle,
      :distribution_key_handle,
      :is_accessible,
      :opening_account_handle,
      :total_from_handle,
      :type,
      :vat_account_handle
    
    
    def handle
      Handle.new({:number => @number})
    end
    
    protected

    def initialize_defaults
      self.name = "Test"
      self.balance = 0
      self.block_direct_entries = false
      self.debit_credit = "Debit"
      self.department_handle = nil
      self.distribution_key_handle = nil
      self.is_accessible = true
      self.type = "ProfitAndLoss"
      self.vat_account_handle = nil
      self.contra_account_handle = nil
      self.opening_account_handle = nil
      self.total_from_handle = nil
    end
    
    def build_soap_data
      data = ActiveSupport::OrderedHash.new

      data['Handle'] = handle.to_hash
      data['Number'] = number
      data['Name'] = name
      data['Type'] = type
      data['DebitCredit'] = debit_credit unless debit_credit.blank?
      data['IsAccessible'] = is_accessible unless is_accessible.blank?
      data['BlockDirectEntries'] = block_direct_entries
      if (type == "ProfitAndLoss" || type == "Status")
        data['VatAccountHandle'] = { 'VatCode' => vat_account_handle[:vat_code] } unless vat_account_handle.blank?
        data['ContraAccountHandle'] = { 'Number' => contra_account_handle[:number] } unless contra_account_handle.blank?
      end

      data['OpeningAccountHandle'] = { 'Number' => opening_account_handle[:number] } unless opening_account_handle.blank? || type != "Status"
      data['TotalFromHandle'] = { 'Number' => total_from_handle[:number] } unless total_from_handle.blank? || type != "TotalFrom"
      data['Balance'] = balance
      
      data['DepartmentHandle'] = { 'Number' => department_handle[:number] } unless department_handle.blank?
      data['DistributionKeyHandle'] = { 'Number' => distribution_key_handle[:number] } unless distribution_key_handle.blank?

      return data
    end
  end
end
