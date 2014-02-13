require 'spec_helper'
require 'date_range'

describe DateRange do
  let(:date_range) { DateRange.new }

  context 'no start date is given' do
    it 'should default to 1 month ago' do
      date_range.start_date.should == 1.month.ago.to_date
    end
  end

  context 'no end date is given' do
    it 'should default to 1 month ago' do
      date_range.end_date.should == Date.today
    end
  end

  it 'should be able to set active' do
    date = 2.months.from_now
    date_range.should be_in_range(date)
    date_range.is_active = true
    date_range.should_not be_in_range(date)
  end

end