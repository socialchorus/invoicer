require 'report'
require 'spec_helper'

describe Report do

  let(:date_range) { DateRange.new(start_date: 10.days.ago, end_date: 15.days.from_now) }
  let(:report) {
    Report.new(customers, date_range)
  }
  let!(:customers) { [Customer.make!, Customer.make!] }

  context 'when not using a date range' do

    let!(:invoice) { Invoice.make!(customer: customers[0]) }

    it 'should return all invoices as items' do
      report.generate
      report.should have(1).items
    end

    it 'should not have any balance forward' do
      report.calculate_balance_forward
      report.generate
      report.balances.should be_empty
    end

  end

  context 'when date range is active' do
    let!(:invoice2) { Invoice.make!(customer: customers[0], issue_date: 15.days.ago, total: 100) }
    let!(:invoice3) { Invoice.make!(customer: customers[1]) }

    let(:report) {
      date_range.is_active = true
      Report.new(customers,date_range)
    }

    it 'should return matching invoices as items' do
      report.generate
      report.should have(1).items
      report.items.first.customer_id.should == invoice3.customer_id
    end

    it 'should calculate balance forward and attach to item' do
      report.calculate_balance_forward
      report.generate
      report.balances[invoice2.customer_id].should == 100
    end
  end
end