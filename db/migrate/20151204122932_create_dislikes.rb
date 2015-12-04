class CreateDislikes < ActiveRecord::Migration
  def change
    create_table :dislikes do |t|
      t.belongs_to :user
      t.belongs_to :product

      t.timestamps null: false
    end
  end
end
