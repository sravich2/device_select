class CreateCriticReviews < ActiveRecord::Migration
  def change
    create_table :critic_reviews do |t|

      t.timestamps null: false
    end
  end
end
