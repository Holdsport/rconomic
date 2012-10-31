module Economic
  class Session
    attr_accessor :token

    def initialize(token)
      self.token = token
    end

    # Returns the Savon::Client used to connect to e-conomic
    def client
      @client ||= Savon::Client.new do
        wsdl.document = File.expand_path(File.join(File.dirname(__FILE__), "economic.wsdl"))
      end
    end

    # Authenticates with e-conomic
    def connect_with_token
      response = client.request :economic, :connect_with_token do
        soap.body = {
          :token => self.token,
          :order! => [:token]
        }
      end
      client.http.headers["Cookie"] = response.http.headers["Set-Cookie"]
    end

    # Provides access to the DebtorContacts
    def contacts
      @contacts ||= DebtorContactProxy.new(self)
    end

    # Provides access to the current invoices - ie invoices that haven't yet been booked
    def current_invoices
      @current_invoices ||= CurrentInvoiceProxy.new(self)
    end

    # Provides access to the invoices
    def invoices
      @invoices ||= InvoiceProxy.new(self)
    end

    # Provides access to the debtors
    def debtors
      @debtors ||= DebtorProxy.new(self)
    end

    # Provides access to the debtor groups
    def debtor_groups
      @debtor_groups ||= DebtorGroupProxy.new(self)
    end

    # Provides access to the template collections
    def template_collections
      @template_collections ||= TemplateCollectionProxy.new(self)
    end

    # Provides access to the term of payments
    def term_of_payments
      @term_of_payments ||= TermOfPaymentProxy.new(self)
    end

    # Provides access to the product groups
    def product_groups
      @product_groups ||= ProductGroupProxy.new(self)
    end

    # Provides access to the products
    def products
      @products ||= ProductProxy.new(self)
    end

    # Provides access to creditors
    def creditors
      @creditors ||= CreditorProxy.new(self)
    end

    def cash_books
      @cash_books ||= CashBookProxy.new(self)
    end

    def cash_book_entries
      @cash_book_entries ||= CashBookEntryProxy.new(self)
    end

    def accounts
      @accounts ||= AccountProxy.new(self)
    end

    def debtor_entries
      @debtor_entries ||= DebtorEntryProxy.new(self)
    end

    def creditor_entries
      @creditor_entries ||= CreditorEntryProxy.new(self)
    end

    def entries
      @entries ||= EntryProxy.new(self)
    end

    def request(action, &block)
      response = client.request :economic, action, &block
      response_hash = response.to_hash

      response_key = "#{action}_response".intern
      result_key = "#{action}_result".intern
      if response_hash[response_key] && response_hash[response_key][result_key]
        response_hash[response_key][result_key]
      else
        {}
      end
    end

    # Returns self - used by proxies to access the session of their owner
    def session
      self
    end
  end
end
