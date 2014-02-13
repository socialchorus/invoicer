require 'machinist/active_record'

Customer.blueprint do
  name { "Customer #{rand(100)}" }
  email { "customer_#{rand(100)}@example.com" }
end

Invoice.blueprint do
  customer
  total { rand(1000) }
  issue_date { Date.today }
end