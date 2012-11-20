require 'economic/entity'

module Economic

  # Represents a term of payment.
  #
  # API documentation: http://e-conomic.github.com/eco-api-sdk-ref-docs/Documentation/
  #
  # Examples
  #
  #   # Find a term of payment
  #   term = economic.term_of_payments.find(1)

  class TermOfPayment < Entity
    has_properties  :name,
                    :id,
                    :type,
                    :contra_account_handle,
                    :contra_account2_handle,
                    :days,
                    :debtor_handle,
                    :description,
                    :distribution_in_percent,
                    :distribution_in_percent2

    def handle
      Handle.new({:id => @id})
    end

    protected

    def initialize_defaults
      self.type = 'PaidInCash'
      self.days = nil
      self.contra_account2_handle = nil
      self.debtor_handle = nil
      self.distribution_in_percent = nil
      self.distribution_in_percent2 = nil
    end

    def build_soap_data
      data = ActiveSupport::OrderedHash.new

      data['Handle'] = handle.to_hash
      data['Id'] = id
      data['Name'] = name
      data['Type'] = type
      data['Days'] = days
      data['Description'] = description unless description.blank?
      data['ContraAccountHandle'] = { 'Number' => contra_account_handle[:number] } unless contra_account_handle.blank?
      data['ContraAccount2Handle'] = { 'Number' => contra_account2_handle[:number] } unless contra_account2_handle.blank?
      data['DebtorHandle'] = { 'Number' => debtor_handle[:number] } unless debtor_handle.blank?
      data['DistributionInPercent'] = distribution_in_percent
      data['DistributionInPercent2'] = distribution_in_percent2

      return data

    end

  end
end