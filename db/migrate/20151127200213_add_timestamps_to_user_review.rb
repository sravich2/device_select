class AddTimestampsToUserReview < ActiveRecord::Migration
  def change
      change_table :user_reviews do |t|
        t.timestamps
    end
  end
end
