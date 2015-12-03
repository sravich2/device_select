class CreatePossessions < ActiveRecord::Migration
  def change
    create_table :possessions do |t|
      t.belongs_to :user
      t.belongs_to :product

      t.timestamps null: false
    end
  end
end
