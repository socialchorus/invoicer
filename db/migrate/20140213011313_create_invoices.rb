class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :customer_id
      t.date :issue_date
      t.float :total

      t.timestamps
    end
  end
end
