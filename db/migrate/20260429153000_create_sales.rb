class CreateSales < ActiveRecord::Migration[8.1]
  def change
    create_table :sales do |t|
      t.references :product, null: false, foreign_key: true
      t.string :buyer_name, null: false
      t.string :buyer_email, null: false
      t.integer :quantity, null: false, default: 1

      t.timestamps
    end
  end
end
