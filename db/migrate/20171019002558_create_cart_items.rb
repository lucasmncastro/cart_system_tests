class CreateCartItems < ActiveRecord::Migration[5.1]
  def change
    create_table :cart_items do |t|
      t.references :cart, foreign_key: true
      t.references :product, foreign_key: true
      t.integer :quantity, default: 1
      t.decimal :unit_price
      t.decimal :total_price

      t.timestamps
    end
  end
end
