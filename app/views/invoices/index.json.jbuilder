json.array!(@invoices) do |invoice|
  json.extract! invoice, :id, :customer_id, :issue_date, :total
  json.url invoice_url(invoice, format: :json)
end
