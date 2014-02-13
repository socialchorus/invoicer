require_relative 'invoice_item'

class Report

  attr_accessor :use_date_range
  attr_reader :items, :balances, :customer_ids

  # @param customers {Customer}
  def initialize(customers, params={})
    @customer_ids = Array(customers).map(&:id)
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @use_date_range = params[:use_date_range]
    @balances = Hash.new(0)
    @items = []
  end

  # calculate balances for invoices prior to the start date, when searching by date range
  def calculate_balance_forward
    invoices.each do |invoice|
      if date_range_active? && invoice.issue_date < start_date
        @balances[invoice.customer_id] += invoice.amount_due
      end
    end
  end

  # collect the applicable invoices and add on balance forward
  def generate
    invoices.each do |invoice|
      if !date_range_active? || (invoice.issue_date >= start_date && invoice.issue_date <= end_date)
        items << InvoiceItem.new(invoice.customer_id, invoice.issue_date, invoice.total)
      end
    end
  end

  def start_date
    (@start_date || 1.month.ago).to_date
  end

  def end_date
    @end_date.try(:to_date) || Date.today
  end

  def date_range_active?
    use_date_range == '1'
  end

  private

  def invoices
    @invoices ||= Invoice.where(customer_id: customer_ids).order(:issue_date)
  end

end