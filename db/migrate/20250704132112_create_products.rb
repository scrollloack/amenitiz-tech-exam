class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :product_code
      t.string :name
      t.decimal :price

      t.timestamps
    end
    add_index :products, :product_code, unique: true
  end
end
