class CreateAnalyticsStats < ActiveRecord::Migration
  def change
    create_table :analytics_stats do |t|
      t.belongs_to :product
      t.integer :like_count
      t.integer :have_count
      t.integer :price
      t.date :date
      t.timestamps null: false
    end
  end
end
