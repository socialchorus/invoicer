class Invoice < ActiveRecord::Base
  belongs_to :customer

  def amount_due
    total
  end

end
