require_relative 'invoice_item'
require_relative 'date_range'

class Report

  attr_reader :items, :balances, :customer_ids, :date_range

  # @param customers {Customer}
  def initialize(customers, date_range)
    @customer_ids = Array(customers).map(&:id)
    @date_range = date_range
    @balances = Hash.new(0)
    @items = []
  end

  # calculate balances for invoices prior to the start date, when searching by date range
  def calculate_balance_forward
    invoices.each do |invoice|
      if date_range.is_active? && invoice.issue_date < date_range.start_date
        @balances[invoice.customer_id] += invoice.amount_due
      end
    end
  end

  # collect the applicable invoices
  def generate
    invoices.each do |invoice|
      if date_range.in_range?(invoice.issue_date)
        items << InvoiceItem.new(invoice.customer_id, invoice.issue_date, invoice.total)
      end
    end
  end

  private

  def invoices
    @invoices ||= Invoice.where(customer_id: customer_ids).order(:issue_date)
  end

end