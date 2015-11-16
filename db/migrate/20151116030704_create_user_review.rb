class CreateUserReview < ActiveRecord::Migration
  def change
    create_table :user_reviews do |t|
      t.belongs_to :user
      t.belongs_to :product
      t.integer :rating
      t.string :comment
    end
  end
end
