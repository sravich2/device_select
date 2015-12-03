class CreateAnalyticsStats < ActiveRecord::Migration
  def change
    create_table :analytics_stats do |t|
      t.belongs_to :product
      t.integer :like_count
      t.integer :have_count
      t.float :price

      t.timestamps null: false
    end
  end
end
