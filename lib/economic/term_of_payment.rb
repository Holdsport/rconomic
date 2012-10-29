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

  end
end