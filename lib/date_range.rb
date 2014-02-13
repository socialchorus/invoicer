class DateRange

  attr_accessor :is_active
  attr_reader :start_date, :end_date

  def initialize(params={})
    @start_date = (params[:start_date] || 1.month.ago).to_date
    @end_date = params[:end_date].try(:to_date) || Date.today
    @is_active = params[:use_date_range] == '1'
  end

  def in_range?(date)
    !is_active? || (date >= start_date && date <= end_date)
  end

  def is_active?
    is_active
  end
end