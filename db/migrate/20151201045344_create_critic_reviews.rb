class CreateCriticReviews < ActiveRecord::Migration
  def change
    create_table :critic_reviews do |t|
      t.belongs_to :product
      t.string :url
      t.float :rating
      t.text :page_html
      t.timestamps null: false
    end
  end
end
