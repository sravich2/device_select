class CreateProduct < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :processor
      t.string :screen_size
      t.string :name
      t.string :memory
      t.string :camera
      t.string :battery

      t.timestamps
    end
  end
end
