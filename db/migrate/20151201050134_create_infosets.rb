class CreateInfosets < ActiveRecord::Migration
  def change
    create_table :infosets do |t|
      t.belongs_to :product
      t.belongs_to :seller
      t.float :price
      t.string :url
      t.datetime :date

      t.timestamps null: false
    end
  end
end
